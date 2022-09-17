class Menu < ApplicationRecord
  #has_many :filhos, class_name: "Menu", foreign_key: "pai_id"
  #has_and_belongs_to_many :pai, class_name: "Menu"
  
  before_save:valida
  def valida
	if Menu.select("count(id) as quantidade").where(pai_id: self.id,id:self.pai_id).first.quantidade>0
		self.errors.add(:pai_id, :has_recursive,nome: self.nome)
		throw :abort
	end
	gera_link
  end
  
  def gera_link
	self.link=self.nome.parameterize.to_s
	self.link=self.link.gsub(" ", "_")
	self.link=self.link.gsub("-", "_")
	self.link=self.link.gsub("+", "_")
	self.link=self.link.gsub("&", "e")
	self.link=self.link.gsub("?", "_")
	self.link=self.link.gsub("=", "_")
  end
  
  before_destroy :tem_filhos?
  def tem_filhos?
	_resultado=true
	if Menu.select("count(id) as quantidade").where(pai_id: self.id).first.quantidade>0
		self.errors.add(:pai_id, :has_child_menu,nome: self.nome)
		_resultado=false
	end
	if GaleriaVideo.select("count(id) as quantidade").where(menu_id: self.id).first.quantidade>0
		self.errors.add(:pai_id, :has_child_foto,nome: self.nome)
		_resultado=false
	end
	if GaleriaFoto.select("count(id) as quantidade").where(menu_id: self.id).first.quantidade>0
		self.errors.add(:pai_id, :has_child_video,nome: self.nome)
		_resultado=false
	end
	if Noticia.select("count(id) as quantidade").where(menu_id: self.id).first.quantidade>0
		self.errors.add(:pai_id, :has_child_noticia,nome: self.nome)
		_resultado=false
	end
	if (_resultado)
		Politica.new.deleter_politica_por_menu(self.id)
	else
		throw :abort
	end
  end
  
  def linkPorNivel(_menu,simbolo)
	_link=_menu.link
	while true
		_menu=menuPai(_menu)
		if _menu.nil?
			break
		else
			_link=_menu.link+simbolo+@link
		end
	end
	return _link
  end
  
  def submenu(_menu)
	return (_menu.nil?)? Menu.where("pai_id is null"): Menu.where(pai_id: _menu.id)
  end
  
  def menuPai(_menu)
	return (_menu.nil?)? nil: Menu.where(id: _menu.pai_id)
  end
  
  def menuPorNivel(_menu,simbolo)
	_nome=_menu.nome
	while true
		_menu=menuPai(_menu)
		if _menu.nil?
			break
		else
			_nome=_menu.nome+simbolo+@nome
		end
	end
	return _nome
  end
  
  def menusPorNivel(simbolo,_usuario_id)
     _menus=Menu.select("distinct menus.*")
	.joins("inner JOIN Politicas ON (Politicas.menu_id= menus.id)")
	.joins("inner JOIN perfis ON (politicas.perfil_id= perfis.id)")
	.joins("inner JOIN perfis_usuarios ON (perfis_usuarios.perfil_id=perfis.id)")
	.joins("inner JOIN usuarios on (usuarios.id=perfis_usuarios.usuario_id and usuarios.id=0"+_usuario_id.to_s+")").order(:pai_id)
	if(_menus.length==0)
		_menus  =Menu.all.order(:pai_id)
	end
	_menus_ordenados= Array.new
	_menus.each do |mp|
		_menus_ordenados.push(mp) if (_menus_ordenados.index(mp).nil?)
		_menus.each do |m|
			if(mp.id==m.pai_id)
				m.nome=mp.nome+simbolo+m.nome 
				_menus_ordenados.push(m)
			end
		end
	end	
	_menus.each do |mp2|
		_menus=_menus_ordenados
		_menus_ordenados= Array.new
		_menus.each do |mp|
			_menus_ordenados.push(mp) if (_menus_ordenados.index(mp).nil?)
			_menus.each do |m|
				if(mp.id==m.pai_id)
					_menus_ordenados.push(m)
				end
			end
		end	
	end	
	return _menus_ordenados
  end
  def ultimo
	return Menu.all.order("id desc").limit(1).first
  end
end
