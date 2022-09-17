class AdmController < ApplicationController
  def painel
	@sistemas=Sistema.new.sistemas_permitidos_por_usuario(session[:usuario_id])
  end

  def senha_trocada_com_sucesso
  end
  
  def login
	session.clear
	@usuario=Usuario.new
	if (params[:acao]=="Enviar")
		@usuario=Usuario.new.logon(params[:login],params[:senha])
		if (!@usuario.nil? and !@usuario.blank? and !@usuario.id.nil? and @usuario.tentativas_falhadas == 0)
			session[:usuario_id]=@usuario.id  
			session[:usuario_nome]=@usuario.nome  
			session[:inicio_sessao]=Time.now
			redirect_to :controller => "adm", :action => "painel" 
		end
	end  
  end
  
  def esqueceu_a_senha
		@usuario=Usuario.new
		meu_usuario=Usuario.new
		if (params[:acao]=="Enviar")
			@usuario=meu_usuario.autentica_email(params[:email])
			flash[:success]="O Código de recuperação foi enviado para o e-mail com sucesso "+@usuario.email
			if meu_usuario.errors.nil?
				UsuarioMailer.recuperar_senha(@usuario).deliver
			end
		end
  end
  
  def cadastre_se
  	session.clear
	@usuario=Usuario.new
	if (params[:acao]=="Salvar")
		if(@usuario.valida_nova_senha(params[:senha],params[:repetir_senha]))
		  @usuario.nome=params[:nome]
		  @usuario.login=params[:login]
		  @usuario.email=params[:email]
		  @usuario.tentativas_falhadas=0
		  @usuario.save
     	  flash[:success]="Usuario cadastrado com sucesso! "
		end
	end
  end
  
  def codigo_verificacao
	@usuario=Usuario.new
	if (params[:acao]=="Enviar")
		@usuario=Usuario.new.confere_codigo_verificacao(params[:login],params[:codigo_verificacao])
		if !@usuario.nil?
			session[:usuario_trocar_senha]=@usuario
			controller.redirect_to :controller => "adm", :action => "trocar_senha" 
		end
	end  
  end 
  
  def trocar_senha
	@usuario=Usuario.new
	if (params[:acao]=="Enviar")
		@usuario=Usuario.create(session[:usuario_trocar_senha])
		if @usuario.trocar_senha(params[:senha],params[:repetir_senha])
			if @usuario.errors.messages[:senha].first.nil? 
				controller.redirect_to :controller => "adm", :action => "senha_trocada_com_sucesso" 
			end
		end
	end
  end

  def tempo_sessao
	tempo=(Time.now - session[:inicio_sessao].to_time).round()
	session[:contador_tempo_sessao] = (tempo<10.minutes)? tempo:0
	response.write(Time.at(tempo).utc.strftime("%H:%M:%S"))
  end
  def acesso_restrito
  end
end
