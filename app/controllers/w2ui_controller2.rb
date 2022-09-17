class W2uiController < ActionController::Base
	def index
		@app= (params[:app].nil?) ? '' : params[:app]
		if(@app=='session')
			tempo=(Time.now - session[:inicio_sessao].try(:to_time)).try(:round)
			if(tempo<10.minutes)
			  	response.write(Time.at(10.minutes-tempo).utc.strftime("%H:%M:%S"))  
			else
				session.clear
			end
		elsif (@app=='authenticity_token')
			response.write(form_authenticity_token)
		else	
			render :index
		end
	end

	def file_assets
		inicio=(getWebBaseDir).length
		acumulador=request.url[inicio,request.url.length]
		acumulador.split("/").each do
			path_file_assets=request.url[inicio,request.url.length].split("?")[0]
			if(File.directory?("./public/"+path_file_assets))
				_parameter=""
				if(request.url[inicio,request.url.length].index("?")>0)
					_parameter="?"+request.url[inicio,request.url.length].split("?")[1]
				end
				redirect_to getWebBaseDir+path_file_assets+_parameter
				inicio=-1
				break;
			elsif(File.exist?("./public/"+path_file_assets))
				send_file("./public/"+path_file_assets, type: MIME::Types.type_for(path_file_assets).first.content_type, disposition: 'inline')
				inicio=-1
				break;
			else
				inicio=inicio+path_file_assets.split("/")[0].length+1
			end
		end
		if (inicio!=-1)
			raise ActionController::RoutingError.new('Not Found')
		end
	end

	
	def getWebBaseDir
		web_basedir_=request.url
		dominio=""
		acumulador = web_basedir_.split("/")
		i=0
		acumulador.each do |a,index|
			if(i>1)and(a.length>1)
				dominio=a
				break;
			end
			i=i+1
		end
		web_basedir_=web_basedir_[0,web_basedir_.index(dominio)+dominio.length+1]
		return web_basedir_
	end
end