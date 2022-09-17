class PerfisUsuariosController < ApplicationController
  def index
	@acesso=acesso(nil)
    @usuarios = Usuario.all
	@Usuario_id=(params[:Usuario_id].nil? or params[:Usuario_id].blank?)? session["usuario_id"]:params[:Usuario_id]
    @usuario = Usuario.find(@Usuario_id.to_i)
    @perfis = Perfil.all
	@perfis_usuario=PerfisUsuario.new
	if(params[:acao]=="Salvar")
		_Perfis=params[:Perfis]
		if !(_Perfis.nil?)
			PerfisUsuario.where(usuario_id:@Usuario_id).destroy_all
			_Perfis.each do |index,_Perfil| 
				PerfisUsuario.create(Usuario_id:@Usuario_id,Perfil_id:_Perfil[:id])
			end
		end
	end
  end

end
