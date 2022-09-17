require 'digest'

class Usuario < ApplicationRecord
  LIMITE_TENTATIVAS_BLOQUEIO=3
  REQUISITOS_SENHA = /\A
	(?=.{8,})                             # Pelo menos conter 8 caracteres,
	(?=.*\d)                              #                   1 número,
	(?=.*[a-z])                           #                   1 letra minuscula,
	(?=.*[A-Z])                           #                   1 letra maiuscula,
	(?=.*[[:^alnum:]])                    #                   1 caractere especial
  /x
  
  REQUISITOS_LOGIN = /\A
	(?:[a-zA-Z]                			  # Pelo menos conter 3 caracteres,
	[-a-z0-9]{2,})                        #                   começar por letras,
  /x                                      #                  pode terminar com numero e letra
  
  REQUISITOS_EMAIL = /\A
	(?:[a-zA-Z]                           # deve Começar por letras,
	[-a-z0-9]{1,}                         # pode conter números,
	@                                     # terminar com "@" 
	[a-zA-Z]+[-a-z0-9]{1,}                # e nome do domíninio 
 	\.[a-zA-Z]+[-a-z0-9]{1,}	          # exemplo email@email.com, email1@email.com
   )	
  /x
  before_save:cripitograr_senha
  def cripitograr_senha
	if (!self.senha.nil?)and(tentativas_falhadas==0)
      self.senha=(Digest::SHA2.new(512).hexdigest self.senha).to_s	
    end
  end
  
  validates :nome,  length: { minimum: 3 }, presence: true
  validates :login, presence: true, format: {with: REQUISITOS_LOGIN, on: :create}, uniqueness: {case_sensitive: false}
  validates :senha,:confirmation => true, presence: true, format: {with: REQUISITOS_SENHA, on: :create}
  validates :email, presence: true, format: {with: REQUISITOS_EMAIL, on: :create}, uniqueness: {case_sensitive: false}
  #validates_numericality_of :tentativas_falhadas, less_than: LIMITE_TENTATIVAS_BLOQUEIO
  
  has_attached_file :foto, 
  					styles:      		{ tela_cheia: "1024x768>",            grande: "640x480>",			media: "320x240>",			pequena: "160x120>", 			ico: "32x32#" },
  					convert_options: 	{ tela_cheia: "-quality 75 -strip",   grande: "-quality 75 -strip", media: "-quality 75 -strip",pequena: "-quality 75 -strip", 	ico: "-quality 75 -strip"},
					default_url: "/assets/img/usuario_padrao.png"
  validates_attachment_content_type :foto, content_type: ['image/jpeg','image/jpg', 'image/png'] ,size: {in: 0..10.megabytes }					
  #validates :foto, dimensions: { width:  160, height: 120 }
  
  def logon(_login,_senha)
	_Usuario=nil
    if (!_senha.nil?) and (!_login.nil?)
		_Usuario=self.autentica_login(_login,_senha)
		if(!_Usuario.nil?)
			_Usuario=zera_tentativas_falhadas(_login)
		else
			_Usuario=self.incrementa_tentativas_falhadas(_login)
			if(_Usuario.try(:tentativas_falhadas).nil?)
				_Usuario=Usuario.new
				_Usuario.errors.add(:tentativas_falhadas, :invalid)
			elsif(_Usuario.tentativas_falhadas<LIMITE_TENTATIVAS_BLOQUEIO)
				_Usuario.errors.add(:tentativas_falhadas, :password_invalid,count:_Usuario.tentativas_falhadas,limit:LIMITE_TENTATIVAS_BLOQUEIO)
			else
				_Usuario.errors.add(:tentativas_falhadas, :less_than,limit:LIMITE_TENTATIVAS_BLOQUEIO)
			end
		end
	end
	return _Usuario
  end
  
  def autentica_login(_login,_senha)
    return Usuario.where(login: _login,senha:(Digest::SHA2.new(512).hexdigest _senha).to_s).first
  end
  
  def gerar_codigo_verificacao
	_Usuario =Usuario.where(login: self.login)
	_Usuario.update(updated_at:Time.now)
	return _Usuario.first.mostrar_codigo_verificacao
  end
  
  def mostrar_codigo_verificacao
	return Math.sqrt((self.updated_at.to_f*100000).to_i.to_s[-6,6].to_i).to_s[-6,6].to_i
  end
  
  def confere_codigo_verificacao(_login,_codigo_verificacao)
	_Usuario =Usuario.where(login: _login).first
	_Usuario= (!_Usuario.nil? and _Usuario.mostrar_codigo_verificacao.to_s == _codigo_verificacao.to_s)? _Usuario:nil;
	if _Usuario.nil?
	  _Usuario.errors.add(:login, :codigo_verificacao)
	end
  end
  
  def incrementa_tentativas_falhadas(_login)
    _Usuario =Usuario.where(login: _login)
	if(!_Usuario.first.nil?)
		_tentativas_falhadas=_Usuario.first.tentativas_falhadas+1
		_Usuario.update(tentativas_falhadas:_tentativas_falhadas)
		_Usuario=_Usuario.first
		_Usuario.tentativas_falhadas=_tentativas_falhadas
	end
	return _Usuario
  end
  
  def zera_tentativas_falhadas(_login)
    _Usuario =Usuario.where(login: _login).first
	if(!_Usuario.nil?)and(_Usuario.tentativas_falhadas!=0)
	_Usuario.tentativas_falhadas=0
		sql='UPDATE "usuarios" SET "tentativas_falhadas" = 0	WHERE "usuarios"."id" = 0'+_Usuario.id.to_s
		ActiveRecord::Base.connection.execute(sql)
	end
	return _Usuario
  end

  def autentica_email(_email)
	_Usuario=Usuario.new
    if (!_email.nil?)  
	  _Usuario=Usuario.where(email: _email).first
	  if(_Usuario.nil?)
	     self.errors.add(:email, :not_found,e_mail:_email)
	  end
	end
	return _Usuario
  end
  
  def valida_nova_senha(_senha,_repetir_senha)
	if(_senha==_repetir_senha)
		self.senha=_senha
		return true
	else
	   self.errors.add(:senha, :confirm)
       return false
	end
  end
  
  def trocar_senha(_senha,_repetir_senha)
	if(self.valida_nova_senha(_senha,_repetir_senha))		
		Usuario.where(id:self.id).update(tentativas_falhadas:0,senha:_senha)
		return true
	else
       return false
	end
  end
  
  def mensagem_erro(campo)
	return self.try(:errors).try(:messages)[campo].join(',')
  end
  
  def tem_erro(campo)
	return ((!mensagem_erro(campo).nil?) and (!mensagem_erro(campo).blank?))
  end
end