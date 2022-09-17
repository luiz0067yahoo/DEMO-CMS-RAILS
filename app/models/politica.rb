
class Politica < ApplicationRecord
  belongs_to :Perfil
  has_and_belongs_to_many :Menu
  belongs_to :Sistema
  
  def consulta(_perfil_id,_menu_id,_sistema_id)
	@_politica=Politica.new(Perfil_id:_perfil_id,Sistema_id:_sistema_id,ver:false,editar:false,novo:false,salvar:false,excluir:false,atualizar:false)
	_acc=@_politica
	if !(_perfil_id.nil?) and !(_sistema_id.nil?)
		@_politica.Perfil_id=_perfil_id
		if (_menu_id == "todos")
			_acc=Politica.select("avg(ver)==1 as ver,avg(editar)==1 as editar,avg(novo)==1 as novo,avg(salvar)==1 as salvar,avg(excluir)==1 as excluir,avg(atualizar)==1 as atualizar")
			.where(perfil_id:_perfil_id,sistema_id:_sistema_id).first
		else
			if !(_menu_id.nil?) and !(_menu_id.blank?)
				@_politica.Menu_id=_menu_id
			end
			_acc=Politica.where(perfil_id:_perfil_id,menu_id: _menu_id,sistema_id:_sistema_id).first
		end
	end
	if !(_acc.nil?)
		@_politica=_acc
	end
	return @_politica
  end
  
  
   def consultaHieraquica(_perfil_id,_menu_id,_sistema_id)
	@_politica=Politica.new(Perfil_id:_perfil_id,Sistema_id:_sistema_id,ver:false,editar:false,novo:false,salvar:false,excluir:false,atualizar:false)
	_menu=Menu.where("id=0"+_menu_id.to_s).first
	while(true)
		_acc=@_politica
		if !(_perfil_id.nil?) and !(_sistema_id.nil?)
			@_politica.Perfil_id=_perfil_id
			if !(_menu_id.nil?) and !(_menu_id.blank?)
				@_politica.Menu_id=_menu_id
			end
			_acc=Politica.where(perfil_id:_perfil_id,menu_id: _menu_id,sistema_id:_sistema_id).first
		end
		if !(_acc.nil?)
			@_politica=_acc
			break
		elsif (_menu.pai_id.nil?)
			_menu=Menu.where("id=0"+_menu.pai_id).first
		else
			break
		end
	end
	return @_politica
  end
  
  
  
  def consultaPoliticaDePerfilPorUsuario(_Usuario_id,_menu_id,_sistema_id)
	 
	if (_menu_id.nil?) or (_menu_id.blank?) 
	return Politica.select("Max(ver) as ver,Max(editar) as editar,Max(novo) as novo,Max(salvar) as salvar,Max(excluir) as excluir,Max(atualizar) as atualizar")
	.joins("inner JOIN perfis ON (politicas.perfil_id= perfis.id)")
	.joins("inner JOIN perfis_usuarios ON perfis_usuarios.perfil_id=perfis.id")
	.joins("inner JOIN usuarios on (usuarios.id=perfis_usuarios.usuario_id and usuarios.id=0"+_Usuario_id.to_s+")")
	.where(" (politicas.sistema_id="+_sistema_id.to_s+")").first
	else
	return Politica.select("Max(ver) as ver,Max(editar) as editar,Max(novo) as novo,Max(salvar) as salvar,Max(excluir) as excluir,Max(atualizar) as atualizar")
	.joins("inner JOIN perfis ON (politicas.perfil_id= perfis.id)")
	.joins("inner JOIN perfis_usuarios ON perfis_usuarios.perfil_id=perfis.id")
	.joins("inner JOIN usuarios on (usuarios.id=perfis_usuarios.usuario_id and usuarios.id=0"+_Usuario_id.to_s+")")
	.where(" (politicas.sistema_id="+_sistema_id.to_s+") and politicas.menu_id =0"+_menu_id.to_s+" ").first
	end
  end

  def acesso(_usuario_id,_menu_id,_url,_method)  
	_usuario_id=(_usuario_id.blank? or _usuario_id.nil?)? 0 : _usuario_id
	_permitir=true
	_politica=Politica.new(ver:true,editar:true,novo:true,salvar:true,excluir:true,atualizar:true)
	_url=_url.split("?")[0]
	if (!_url.index("/adm/").nil?)
		_politica=Politica.new(ver:false,editar:false,novo:false,salvar:false,excluir:false,atualizar:false)
		if(_url.split("adm").length>1)
			x=_url.split("adm")[1].split("/")
			acao=x[x.length-1]
			sitema_path=x[1]
			sistema=Sistema.where(path:sitema_path).try(:first)
			if (acao.is_a? Integer)
				if (_method=="GET")
					acao="show"
				elsif(_method=="POST")
					acao="save"
				elsif (_method=="DELETE")
					acao="destroy"
				elsif (_method=="PUT")
					acao="update"
				end
			end
			if(! sistema.nil?)
				p=self.consultaPoliticaDePerfilPorUsuario(_usuario_id,_menu_id,sistema.id)
				if(!p.ver.nil?)
					_politica=p
				end
				if(acao.blank?)or(acao=="show")
					_permitir=p.ver==true
				elsif(acao=="edit")	
					_permitir=p.editar==true
				elsif(acao=="new")
					_permitir=p.novo==true
				elsif(acao=="save")
					_permitir=p.salvar==true
				elsif(acao=="update")
					_permitir=p.atualizar==true
				elsif(acao=="destroy")
					_permitir=p.excluir==true
				end
				_sistema=sistema
			end			
			
			if(_sistema.nil?)
				_permitir=true
			elsif (_usuario_id==0)
				_permitir=false
			end
		end
	end
	resultado = Class.new() do 
		@permitir=nil
		@politica=nil
		@sistema=nil
		def permitir
			return @permitir
		end
		def politica
			return @politica
		end
		def sistema
			return @sistema
		end
		def params(__permitir,__politica,__sistema)
			@permitir=__permitir
			@politica=__politica
			@sistema=__sistema
		end
	end
	r=resultado.new
	r.params(_permitir,_politica,_sistema)
	return  r
  end
    
  def deleter_politica_por_menu(_menu_id)
	sql='DELETE FROM "POLITICAS" WHERE "POLITICAS"."MENU_ID" = 0'+_menu_id.to_s
	ActiveRecord::Base.connection.execute(sql)
	#Politica.where("menu_id=0"+_menu_id.to_s).destroy_all
  end
  def mensagem_erro(campo)
	return self.try(:errors).try(:messages)[campo].join(',')
  end
  
  def tem_erro(campo)
	return ((!mensagem_erro(campo).nil?) and (!mensagem_erro(campo).blank?))
  end 
  
end
