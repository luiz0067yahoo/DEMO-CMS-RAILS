class PerfisUsuario < ApplicationRecord
  belongs_to :Perfil
  belongs_to :Usuario
  def consulta(_perfil_id,_usuario_id)
    _acc=nil	
	if !(_perfil_id.nil?) and !(_usuario_id.nil?)
		_acc=PerfisUsuario.where(Perfil_id:_perfil_id,Usuario_id: _usuario_id).first
	end
	return _acc
  end
  
  def mensagem_erro(campo)
	return self.try(:errors).try(:messages)[campo].join(',')
  end
  
  def tem_erro(campo)
	return ((!mensagem_erro(campo).nil?) and (!mensagem_erro(campo).blank?))
  end
end
