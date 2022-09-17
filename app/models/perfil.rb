class Perfil < ApplicationRecord
	def adiciona_politica_por_menu_para_perfis_de_usuario(_usuario_id,_menu_id,_sistema_id)
		_perfis_quantidade=consulta_perfis_e_quantidade_permissoes_de_politica_por_menu_para_usuario(_usuario_id,_menu_id)
		_maior=0
		_perfis_quantidade.each do |_perfil|
			if _maior<_perfil.quantidade_permissoes
				_maior=_perfil.quantidade_permissoes
			elsif _maior == _perfil.quantidade_permissoes
				_menu=Menu.where(id:_menu_id.to_s)
				_politica=Politica.new.consulta(_perfil.perfil_id,_menu_id,_sistema_id)
				p=Politica.new.consultaHieraquica(_perfil.perfil_id,_menu_id,_sistema_id)
				if !(_politica.id.nil?) and (_politica.id>0)
					Politica.where(id:_politica.id).update(ver: p.ver,editar: p.editar,novo: p.novo,salvar: p.salvar,excluir: p.excluir)
				else
					_politica.update(Perfil_id:_perfil.perfil_id,Menu_id:_menu_id,Sistema_id:_sistema_id,ver: p.ver,editar: p.editar ,novo: p.novo,salvar: p.salvar,excluir: p.excluir)
				end
			end
		end
	end
	def consulta_perfis_e_quantidade_permissoes_de_politica_por_menu_para_usuario(_usuario_id,_menu_id)
		_acc=nil	
		_acc=Politica.select("count(politicas.id) as quantidade_permissoes , perfis.id as perfil_id, perfis.nome as nome")
		.joins("inner join perfis on(perfis.id=politicas.Perfil_id)")
		.joins("inner join Perfis_Usuarios on(perfis.id=Perfis_Usuarios.Perfil_id)")
		.where("Perfis_Usuarios.Usuario_id=0"+_usuario_id.to_s)
		.group("perfis.id")
		.order(" quantidade_permissoes desc,perfis.id asc")
	return _acc
  end
end
