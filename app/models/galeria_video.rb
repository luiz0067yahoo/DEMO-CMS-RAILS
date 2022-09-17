class GaleriaVideo < ApplicationRecord
  belongs_to :Menu
  def galeriaPermitirdaPorMenuUsuario(_usuario_id)
	return GaleriaVideo.select("galeria_videos.*,menus.nome as menu")
	.joins(:Menu)
	.joins("inner JOIN Politicas ON (Politicas.menu_id= menus.id)")
	.joins("inner JOIN perfis ON (politicas.perfil_id= perfis.id)")
	.joins("inner JOIN perfis_usuarios ON perfis_usuarios.perfil_id=perfis.id")
	.joins("inner JOIN usuarios on (usuarios.id=perfis_usuarios.usuario_id and usuarios.id=0"+_usuario_id.to_s+")")
  end
end
