class ApplicationController < ActionController::Base
	def acesso(_Menu_id)
		tempo=11.minutes
		if !(session[:inicio_sessao].nil?)
			tempo=(Time.now - session[:inicio_sessao].try(:to_time)).try(:round)
		end
		if(tempo>10.minutes)
			reset_session
			redirect_to :controller => "adm", :action => "acesso_restrito" 
		else
			session[:inicio_sessao]=Time.now
			@acesso=Politica.new.acesso(session[:usuario_id],_Menu_id,request.url,request.method)
			if(!@acesso.politica.ver) 
				redirect_to :controller => "adm", :action => "acesso_restrito" 
			end
		end
		return @acesso
	end
	def acesso_sistema(nome_modelo)
		return Politica.new.consultaPoliticaDePerfilPorUsuario(session[:usuario_id],params["Menu_id"],Sistema.where(:nome=>nome_modelo).first.try(:id))
	end
end

