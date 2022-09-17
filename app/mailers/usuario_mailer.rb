class UsuarioMailer < ApplicationMailer
 default from: 'luiz0067@gmail.com' 
 def recuperar_senha(_usuario)
    @link='http://localhost/adm/codigo_verificacao';
    @usuario  = _usuario
    mail(to: @usuario.email, subject: 'Codigo de recuperação de senha')
    #mail(to: 'luiz0067@gmail.com', subject: 'Codigo de recuperação de senha')
  end
  def bem_vido(_usuario)
    @url  = 'http://example.com/login'
    @usuario  = _usuario
    mail(to: _usuario.email, subject: 'Bem vindo ao cms')
  end
  def contato(_usuario)
    @url  = 'http://example.com/login'
    @usuario  = _usuario
	#attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
	#<%= image_tag attachments['image.jpg'].url %>
    mail(to: _usuario.email, subject: 'Bem vindo ao cms')
  end
end
