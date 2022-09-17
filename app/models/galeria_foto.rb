class GaleriaFoto < ApplicationRecord
  belongs_to :Menu
  has_attached_file :foto, styles: 		{ tela_cheia: "1024x768>",            grande: "640x480>",			media: "320x240>",			pequena: "160x120>", 			ico: "32x32#" },
					convert_options: 	{ tela_cheia: "-quality 75 -strip",   grande: "-quality 75 -strip", media: "-quality 75 -strip",pequena: "-quality 75 -strip", 	ico: "-quality 75 -strip"},
					default_url: "/assets/img/sem_foto.png"
  validates_attachment_content_type :foto, content_type: ['image/jpg', 'image/png'] ,size: {in: 0..10.megabytes }					
  validates :foto, dimensions: { width:  160, height: 120 }
  def galeriaPermitirdaPorMenuUsuario(_usuario_id)
	return GaleriaFoto.select("galeria_fotos.*,menus.nome as menu")
	.joins(:Menu)
	.joins("inner JOIN Politicas ON (Politicas.menu_id= menus.id)")
	.joins("inner JOIN perfis ON (politicas.perfil_id= perfis.id)")
	.joins("inner JOIN perfis_usuarios ON perfis_usuarios.perfil_id=perfis.id")
	.joins("inner JOIN usuarios on (usuarios.id=perfis_usuarios.usuario_id and usuarios.id=0"+_usuario_id.to_s+")")
	.group(:id)
  end
end
