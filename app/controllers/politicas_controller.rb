class PoliticasController < ApplicationController
  def index
	@acesso=acesso(nil)
	@politica = Politica.new
	@menus = Menu.new.menusPorNivel(">",session[:usuario_id])
	@perfis = Perfil.all
	_Menu_id=params["Menu_id"]
	if(_Menu_id.nil?) or (_Menu_id=="nenhum")
		@sistemas = Sistema.all
	else
		@sistemas = Sistema.where(permisao_por_menu: true)
	end
	if(params[:acao]=="Salvar")
		_politicas=params[:politicas]
		_menus=nil
		if(!_Menu_id.nil?)and(_Menu_id=="todos")
			_menus=@menus
		else
			_menus=Menu.where(id:_Menu_id)
		end
		if _menus.nil?
			_politicas.each do |index,p| 
				@politica = Politica.new(ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
				@politica=@politica.consulta(params["Perfil_id"],_Menu_id,p["Sistema_id"])
				if !(@politica.id.nil?) and (@politica.id>0)
					Politica.where(id:@politica.id).update(ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
				else
					@politica.update(Perfil_id:params["Perfil_id"],Sistema_id:p["Sistema_id"],ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
				end
			end
		else
			_menus.each do |m|
				_politicas.each do |index,p| 
					if(Sistema.where(id:p["Sistema_id"]).first.try(:permisao_por_menu)==true)
						@politica = Politica.new(ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
						@politica=@politica.consulta(params["Perfil_id"],m.id,p["Sistema_id"])
						if !(@politica.id.nil?) and (@politica.id>0)
							Politica.where(id:@politica.id).update(ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
						else
							@politica.update(Perfil_id:params["Perfil_id"],Menu_id:m.id,Sistema_id:p["Sistema_id"],ver:p["ver"],editar:p["editar"],novo:p["novo"],salvar:p["salvar"],excluir:p["excluir"])
						end
					end
				end
			end
		end
	end
	@politicas = Politica.all
  end
end
