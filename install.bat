#Gemfile 
#gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

bundle install
rails generate bootstrap:install less
rails generate bootstrap:install --no-coffeescript
rails generate bootstrap:install static
cd bin

rails g scaffold Usuario nome:string login:string senha:binary email:string email:string tentativas_falhadas:integer
rake db:migrate
rails generate paperclip Usuario foto
rake db:migrate
rails g bootstrap:themed Usuarios

rails g scaffold Perfil nome:string
rake db:migrate
rails g bootstrap:themed perfis

rails generate model Menu nome:string link:string pai_id:integer 
# has_many :filhos, class_name: "Menu", foreign_key: "pai_id"
#  belongs_to :pai, class_name: "Menu"
rake db:migrate
rails g bootstrap:themed Menus

rails g scaffold Sistema nome:string
rake db:migrate
rails g bootstrap:themed Sistemas

rails g scaffold PerfisUsuario Perfil:references Usuario:references
rake db:migrate
rails g bootstrap:themed perfis_usuarios

rails g scaffold GaleriaFoto nome:string descricao:string Menu:references 
rake db:migrate
rails generate paperclip GaleriaFoto foto
rake db:migrate
rails g bootstrap:themed galeria_fotos

rails g scaffold GaleriaVideo nome:string descricao:string link_youtube:string Menu:references 
rake db:migrate
rails g bootstrap:themed galeria_videos

rails g scaffold Noticia titulo:string subtitulo:string fonte:string conteudo:binary ocultar:boolean Menu:references 
rake db:migrate
rails generate paperclip Noticia foto
rake db:migrate
rails g bootstrap:themed Noticias


rails g scaffold NoticiaFoto nome:string descricao:string Noticia:references 
rake db:migrate
rails generate paperclip NoticiaFoto foto
rake db:migrate
rails g bootstrap:themed noticia_fotos

rails g scaffold NoticiaVideo nome:string descricao:string link_youtube:string Noticia:references 
rake db:migrate
rails g bootstrap:themed noticia_videos




#app\model\usuarios\usuario.rb 
require 'digest'
class Usuario < ApplicationRecord
  REQUISITOS_SENHA = /\A
	(?=.{8,})          # Pelo menos conter 8 caracteres,
	(?=.*\d)           #                   1 número,
	(?=.*[a-z])        #                   1 letra minuscula,
	(?=.*[A-Z])        #                   1 letra maiuscula,
	(?=.*[[:^alnum:]]) #                   1 caractere especial
  /x
  
  REQUISITOS_LOGIN = /\A
	(?=.{3,})          # Pelo menos conter 3 caracteres,
	([^@\s]+)          #                   1 começar por letras,
	(?:[-a-z0-9])      #                   pode terminar com numero e letra
  /x

  before_save:cripitograr_senha
  validates :nome,  length: { minimum: 5 }, presence: true
  validates :login, presence: true, format: {with: REQUISITOS_LOGIN, on: :create}, uniqueness: {case_sensitive: false}
  validates :senha, presence: true, format: {with: REQUISITOS_SENHA, on: :create}, uniqueness: {case_sensitive: true}
  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create}, uniqueness: {case_sensitive: false}
  
   def cripitograr_senha
	if (!self.senha.nil?)
      self.senha=(Digest::SHA2.new(512).hexdigest self.senha).to_s	  
	end 
  end
  def autentica_login(_login,_senha)
    usuario_autenticado=(!_senha.nil? and !_senha.nil?)? usuario_autenticado=Usuario.where(login: _login,senha:self.senha=(Digest::SHA2.new(512).hexdigest _senha).to_s).first : nil;
	return usuario_autenticado
  end
end


#app\views\usuarios\index.erb 
substituir a linha <td><%= usuario.senha %></td> # <td>#####################</td>
substituir a linha <td><%= usuario.email %></td> # <td><a href="mailto:<%= usuario.email %>"><%= usuario.email %></a></td>

#app\views\usuarios\_form.html.erb
substituir a linha <%= f.text_field :senha, :class => 'form-control' %>               # <%= f.password_field :senha, :class => 'form-control' %> 
substituir a linha <div class="form-group"> 											#<div class="form-group <%=f.errors_on?(:nome)?" has-error":"" %>" style="height:100px">
substituir a linha <div class="form-group"> 											#<div class="form-group <%=f.errors_on?(:nome)?" has-error":"" %>" style="height:100px">
substituir a linha <div class="form-group"> 											#<div class="form-group <%=f.errors_on?(:login)?" has-error":"" %>" style="height:100px">
substituir a linha <div class="form-group"> 											#<div class="form-group <%=f.errors_on?(:email)?" has-error":"" %>" style="height:100px">

#app\views\usuarios\show.html.erb
substituir a linha <dd><%= @usuario.senha %></dd> # <dd>##########</dd>

#config\application.rb
  class Application < Rails::Application
	config.i18n.default_locale = :"pt-BR"
   I18n.enforce_available_locales = false 
	config.action_view.field_error_proc = Proc.new { |html_tag, instance| #corrige erros de layout do boostrap
	  html_tag
	}
#app\helpers\form_errors_helper.rb
module FormErrorsHelper
  include ActionView::Helpers::FormTagHelper

  def error_span(attribute, options = {})
    options[:span_class] ||= 'col-lg-offset-2 alert alert-danger'#    options[:span_class] ||= 'help-block'
    options[:error_class] ||= 'col-lg-12'#    options[:error_class] ||= 'has-error'

    if errors_on?(attribute)
      @template.content_tag( :div, :class => options[:error_class] )  do
        content_tag( :label, errors_for(attribute), :class => options[:span_class] )
      end
    end
  end

  def errors_on?(attribute)
    object.errors[attribute].present? if object.respond_to?(:errors)
  end

  def errors_for(attribute)
    object.errors[attribute].try(:join, ', ') || object.errors[attribute].try(:to_s)
  end
end
	
rails g controller adm login cadastre_se painel esqueceu_a_senha

#config\routes.rb
Rails.application.routes.draw do  
  scope '/adm' do
    get   '/',                  to: 'adm#login'
    post  '/',                  to: 'adm#login'
    get   '/painel',            to: 'adm#painel'
    get   '/tempo_sessao',      to: 'adm#tempo_sessao'
    get   '/esqueceu_a_senha',  to: 'adm#esqueceu_a_senha'
    post  '/esqueceu_a_senha',  to: 'adm#esqueceu_a_senha'
    get   '/cadastre_se',       to: 'adm#cadastre_se'
    resources :usuarios
  end
end

rails generate mailer UsuarioMailer
#app\views\usuario_mailer\bem_vindo.html.erb
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1>Welcome to example.com, <%= @user.name %></h1>
    <p>
      You have successfully signed up to example.com,
      your username is: <%= @user.login %>.<br>
    </p>
    <p>
      To login to the site, just follow this link: <%= @url %>.
    </p>
    <p>Thanks for joining and have a great day!</p>
  </body>
</html>
#app\views\usuario_mailer\esqueceu_a_senha.html.erb
#app\views\usuario_mailer\contato.html.erb

#config\initializers\inflections.rb replace https://gist.github.com/mateusg/924574
#config\locales\pt-BR.yml replace https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/pt-BR.yml
#config\locales\application.pt-BR.yml
#pt-BR:
  activerecord:
    models:
      usuario: "usuário"
    attributes:
      usuario:
       id: "Código"
       email: "E-mail"
       created_at: "Criado Em"

#db\seed.rb
require 'digest'
Usuario.delete_all
Usuario.create(:id => 1, :nome=>'Administrador', :login=>'admin', :senha=>'cm5r@ils',:email=>'email@email.com.br',:tentativas_falhadas=>0)
puts "Usuario Administrador criado"
puts (Digest::SHA2.new(512).hexdigest 'cm5r@ils')

rake db:seed
rail s

gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
rails plugin install git://github.com/thoughtbot/paperclip.git
bundle install
rails g paperclip usuario foto







        
 