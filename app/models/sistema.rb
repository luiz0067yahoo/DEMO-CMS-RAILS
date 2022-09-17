class Sistema < ApplicationRecord
	def sistemas_permitidos_por_usuario(_usuario_id)
		return Sistema
				.select("sistemas.*")
				.joins("inner join politicas on(politicas.sistema_id=sistemas.id)")
				.joins("inner join perfis on(perfis.id=politicas.perfil_id)")
				.joins("inner join perfis_usuarios on(perfis_usuarios.perfil_id=perfis.id)")
				.joins("inner join usuarios on(usuarios.id=perfis_usuarios.usuario_id)")
				.where("politicas.ver and usuarios.id=0"+_usuario_id.to_s)
				.group("sistemas.id")
				.order("nome asc")
	end
end
