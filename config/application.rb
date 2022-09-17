require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CMS
  class Application < Rails::Application
	config.i18n.default_locale = :"pt-BR"
    I18n.enforce_available_locales = false  
    config.load_defaults 5.2
	config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
	  html_tag
	}
	config.action_mailer.delivery_method = :smtp
	config.action_mailer.smtp_settings = {
		 :address              => "smtp.gmail.com",
		 :port                 => 587,
		 :user_name            => "luiz0067@gmail.com",
		 :password             => "@Gape456",
		 :authentication       => "plain",
		 :enable_starttls_auto => true
	}
  end
end
