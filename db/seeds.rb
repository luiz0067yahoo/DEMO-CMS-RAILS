require 'digest'
include Rails.application.routes.url_helpers
NoticiaFoto.delete_all
NoticiaVideo.delete_all
GaleriaFoto.delete_all
GaleriaVideo.delete_all
Noticia.delete_all
PerfisUsuario.delete_all
Politica.delete_all
Perfil.delete_all
Politica.delete_all
Usuario.delete_all
Menu.delete_all
Sistema.delete_all

Usuario.create(:id => 1, :nome=>'developer', :login=>'developer', :senha=>'CM5 r@ils', :email=>'developer@email.com.br',:tentativas_falhadas=>0)
puts "Usuario root criado"
Usuario.create(:id => 2, :nome=>'Administrador', :login=>'admin', :senha=>'CM5 r@ils', :email=>'Administrador@email.com.br',:tentativas_falhadas=>0)
puts "Usuario Administrador criado"
Usuario.create(:id => 3, :nome=>'leitor', :login=>'leitor', :senha=>'CM5 r@ils', :email=>'leitor@email.com.br',:tentativas_falhadas=>0)
puts "Usuario Leitor criado"
Usuario.create(:id => 4, :nome=>'teste', :login=>'teste', :senha=>'CM5 r@ils', :email=>'teste@email.com.br',:tentativas_falhadas=>0)
puts "Usuario Teste criado"

puts "------------------------------------------------------"
puts "Perfil Administrador criado"
Perfil.create(:id => 1, :nome=>'Desenvolvedor')
puts "Perfil Desenvolvedor criado"
Perfil.create(:id => 2, :nome=>'Administrador')
puts "Perfil Administrador criado"
Perfil.create(:id => 3, :nome=>'Cliente')
puts "Perfil Cliente criado"
Perfil.create(:id => 4, :nome=>'Colunista')
puts "Perfil Colunista criado"
Perfil.create(:id => 5, :nome=>'Fotografo')
puts "Perfil Fotografo criado"
Perfil.create(:id => 6, :nome=>'Editor')
puts "Perfil Editor criado"
Perfil.create(:id => 7, :nome=>'Anunciante')
puts "Perfil Anunciante criado"
Perfil.create(:id => 8, :nome=>'Leitor')
puts "Perfil Leitor criado"
puts "------------------------------------------------------"
Menu.create(:id => 1, :nome=>'home')
puts "Menu home criado"
Menu.create(:id => 2, :nome=>'Notícias')
puts "Menu Notícias criado"
Menu.create(:id => 3, :nome=>'Esporte')
puts "Menu Esporte criado"
Menu.create(:id => 4, :nome=>'Entretenimento')
puts "Menu Entretenimento criado"
Menu.create(:id => 5, :nome=>'Lazer e Saúde')
puts "Menu Lazer criado"
Menu.create(:id => 6, :nome=>'Fotos')
puts "Menu Fotos criado"
Menu.create(:id => 7, :nome=>'Vídeos')
puts "Menu Vídeos criado"
Menu.create(:id => 8, :nome=>'Quem Somos')
puts "Menu Quem Somos criado"
Menu.create(:id => 9, :nome=>'Trabale Conosco')
puts "Menu Trabale Conosco criado"
puts "------------------------------------------------------"
Menu.create(:id => 10,:pai_id=>2, :nome=>'Brasil')
puts "Sub Menu Notícias->Brasil criado"
Menu.create(:id => 11,:pai_id=>2, :nome=>'Mundo')
puts "Sub Menu Notícias->Mundo criado"
Menu.create(:id => 12,:pai_id=>11, :nome=>'teste')
puts "Sub Menu Notícias->teste"
puts "------------------------------------------------------"
_id=1
Rails.application.eager_load!
ApplicationRecord.descendants.collect { 
	|type| 
	if ((type.name=="NoticiaVideo")or(type.name=="NoticiaFoto")or(type.name=="GaleriaFoto")or(type.name=="GaleriaVideo")or(type.name=="Noticia")or(type.name=="Menu"))
		Sistema.create(:id => _id,:nome=>type.name,:path=>polymorphic_path(type.name.classify.constantize).split("adm/")[1],:permisao_por_menu=>true)
	else
		Sistema.create(:id => _id,:nome=>type.name,:path=>polymorphic_path(type.name.classify.constantize).split("adm/")[1],:permisao_por_menu=>false)
	end
	puts "Sistema #{type.name} criado"
	puts "Path #{polymorphic_path(type.name.classify.constantize).split("adm/")[1]} criado"
	#.singularize.classify.constantize.
	_id=_id+1
}
puts "------------------------------------------------------"
_id=1
sistemas=Sistema.all
menus=Menu.all
sistemas.each do |s|
	if (s.permisao_por_menu)
		Politica.create(:id => _id,:Perfil_id=>1,:Sistema_id=>s.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
		puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(1).nome} "
		_id=_id+1
		menus.each do |m|
			Politica.create(:id => _id,:Perfil_id=>1,:Sistema_id=>s.id,:Menu_id=>m.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
			_id=_id+1
			puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(1).nome} no menu #{m.nome}"
		end
	else
		Politica.create(:id => _id,:Perfil_id=>1,:Sistema_id=>s.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
		_id=_id+1
		puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(1).nome}"
	end
end
puts "------------------------------------------------------"
sistemas.each do |s|
	if (s.permisao_por_menu)
		Politica.create(:id => _id,:Perfil_id=>2,:Sistema_id=>s.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
		puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(2).nome} "
		_id=_id+1
		menus.each do |m|
			Politica.create(:id => _id,:Perfil_id=>2,:Sistema_id=>s.id,:Menu_id=>m.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
			_id=_id+1
			puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(2).nome} no menu #{m.nome}"
		end
	else
		Politica.create(:id => _id,:Perfil_id=>2,:Sistema_id=>s.id,:ver=>true,:editar=>true,:novo=>true,:salvar=>true,:excluir=>true,:atualizar=>true)
		_id=_id+1
		puts "Criado politica de Sistema #{s.nome} para Perfil #{Perfil.find(1).nome}"
	end
end
puts "------------------------------------------------------"

PerfisUsuario.create(:Perfil_id=>1,:Usuario_id=>1)
puts "Ligado usuario #{Usuario.find(1).nome} para Perfil  #{Perfil.find(1).nome} "
PerfisUsuario.create(:Perfil_id=>2,:Usuario_id=>2)
puts "Ligado usuario #{Usuario.find(2).nome} para Perfil  #{Perfil.find(2).nome} "
PerfisUsuario.create(:Perfil_id=>8,:Usuario_id=>3)
puts "Ligado usuario #{Usuario.find(3).nome} para Perfil  #{Perfil.find(8).nome} "