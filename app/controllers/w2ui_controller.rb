require 'json'  
require 'securerandom'
require 'fastimage'

class W2uiController < ActionController::Base
	def index
		img_extendion = [ ".gif", ".jpg", ".jpeg", ".png", ".bmp" , ".svg",".swf"]#tipos permitidos
		server_basedir_upload = './public/assets/upload/ckeditor/';#base para envio de arquivos
		url=params[:url]#pasta que será salvo o arquivo enviado
		#web_basedir = URI.join(request.url, '/' )#calcula a origem da pasta
		web_basedir=self.getWebBaseDir
		web_basedir_upload = web_basedir+'assets/upload/ckeditor/'#pagina web que representa a pasta de envio de arquivos
		
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
			if (url.nil?)
				url=''
			elsif (url!='')
				server_basedir_upload = './public/assets/upload/ckeditor/'+url+'/'
				#web_basedir_upload = web_basedir_upload+url+'/'
				web_basedir_upload = web_basedir.to_s+url.to_s+'/'
			end		
			_functions=params[:functions]
			if (_functions.nil?)
				list_directory=Array.new
				list_files=Array.new
				list=Dir.foreach(server_basedir_upload)
				list=list.sort
				list.each{ |file_name|
					if(file_name=='.')||(file_name=='..')
						next
					end
					full_file_name=server_basedir_upload+file_name
					web_full_file_name=file_name
					if(url!='')
						web_full_file_name=url+"/"+file_name
					end
					date_modify=File.mtime(full_file_name).strftime("%m/%d/%Y %I:%M:%S");
					width=0
					height =0
					img_properties=""
					ext = File.extname(full_file_name).downcase
					if !(img_extendion.index(ext).nil?)
						width, height = FastImage.size(full_file_name)
						img_properties=',"width":"'+width.to_s+'px","height":"'+height.to_s+'px"'
					end  
					if(File.directory?(full_file_name))
						size=0
						Dir.glob(File.join(full_file_name, '**', '*')) { |file| size+=File.size(file) }
						elemet_json=JSON.parse('{"file_name":"'+file_name+'","full_file_name":"'+web_full_file_name+'","date_modify":"'+date_modify+'","file_size":"'+::ApplicationController.helpers.number_to_human_size(size,{precision: 2, separator: '.'})+'","directory":true'+img_properties+'}')
						list_directory.insert(-1,elemet_json)
					else
						elemet_json=JSON.parse('{"file_name":"'+file_name+'","full_file_name":"'+web_full_file_name+'","date_modify":"'+date_modify+'","file_size":"'+::ApplicationController.helpers.number_to_human_size(File.size(full_file_name),{precision: 2, separator: '.'})+'","directory":false'+img_properties+'}')
						list_files.insert(-1,elemet_json)
					end
				}
				list=list_directory+list_files
				response.write(list.to_json)
			elsif (_functions=='web_basedir_upload')
				response.write(web_basedir_upload)
			elsif (_functions=='web_basedir')
				response.write(web_basedir)
			elsif (_functions=='upload')
				files=params[:files];
				if !(files.nil?)
					files.each{ |file|
						file_name=file.original_filename
						size=File.size(file.tempfile)
						if(size < 5.megabytes)
							ext = File.extname(file_name).downcase
							if !(img_extendion.index(ext).nil?)
								while File.exist?(server_basedir_upload+file_name)
									file_name=SecureRandom.hex+ext
								end
								result=web_basedir_upload+file_name
								full_file_name=server_basedir_upload+file_name
								f=File.new(full_file_name,'w+b');
							  	f.syswrite(file.read)
								f.close							
								response.write(result)
							else
								response.write('ERRO! A extesão do arquivo '+ext+' não é um formato de imagem '+img_extendion.to_s)
							end
						else
							response.write('ERRO! O tamanho do arquivo '+file_name+' é '+::ApplicationController.helpers.number_to_human_size(size)+' maior que o maximo permitido 5 MB')
						end
					}
				end
			elsif (_functions=='new_folder')
				folder=params[:folder];
				if !(folder.nil?)
					new_folder=+server_basedir_upload+folder
					if (!File.exists?(new_folder))
						Dir.mkdir(new_folder)
						response.write('A Pasta '+folder+' foi criada com sucesso')
					else
						response.write('A Pasta '+folder+' já existe')						
					end
				end
			elsif (_functions=='find')	
				_functions=_functions
				list_directory=Array.new
				list_files=Array.new
				list=Array.new
				search=params[:search];
				if (search.nil?)
					search=''
				end
				Dir.glob("#{server_basedir_upload}/**/*#{search}*").each{ |full_file_name|
					if(full_file_name=='.')||(full_file_name=='..')
						next
					end
					file_name=File.basename(full_file_name)
					web_full_file_name=full_file_name.split(server_basedir_upload)[1]
					date_modify=File.mtime(full_file_name).strftime("%m/%d/%Y %I:%M:%S");  
					width=0
					height =0
					img_properties=""
					ext = File.extname(full_file_name).downcase
					if !(img_extendion.index(ext).nil?)
						width, height = FastImage.size(full_file_name)
						img_properties=',"width":"'+width.to_s+'px","height":"'+height.to_s+'px"'
					end
					if(File.directory?(full_file_name))
						size=0
						Dir.glob(File.join(full_file_name, '**', '*')) { |file| size+=File.size(file) }
						elemet_json=JSON.parse('{"file_name":"'+file_name+'","full_file_name":"'+web_full_file_name+'","date_modify":"'+date_modify+'","file_size":"'+::ApplicationController.helpers.number_to_human_size(size,{precision: 2, separator: '.'})+'","directory":true'+img_properties+'}')
						list_directory.insert(-1,elemet_json)
					else
						elemet_json=JSON.parse('{"file_name":"'+file_name+'","full_file_name":"'+web_full_file_name+'","date_modify":"'+date_modify+'","file_size":"'+::ApplicationController.helpers.number_to_human_size(File.size(full_file_name),{precision: 2, separator: '.'})+'","directory":false'+img_properties+'}')
						list_files.insert(-1,elemet_json)
					end
				}
				list=list_directory+list_files
				response.write(list.to_json)
			elsif (_functions=='delete')
				file_folder=params[:file_folder];
				full_file_name=''
				if !(file_folder.nil?)
					new_file_folders=file_folder.split(",")
					new_file_folders.each{ |file|
						full_file_name=server_basedir_upload+file
						if(File.directory?(full_file_name))
							FileUtils.rm_rf(full_file_name)
						else
							File.delete(full_file_name)
						end
					}
				end
			elsif (_functions=='redimencion')	
				_functions=_functions
				#convert -resize <largura>x<altura> arquivo_original arquivo_novo
				#image = MiniMagick::Image.open("input.jpg")
				#image.path #=> "/var/folders/k7/6zx6dx6x7ys3rv3srh0nyfj00000gn/T/magick20140921-75881-1yho3zc.jpg"
				#image.resize "100x100"
				#image.format "png"
				#image.write "output.png"
			elsif (_functions=='teste')
				file_name=params[:file_name];
				acc_explorer_upload_files=session[:explorer_upload_files]
				full_file_name=''
				if (!(file_name.nil?)&&!(acc_explorer_upload_files.nil?))
					acc_explorer_upload_files.each do |x|
						acc_index=x.index(file_name)
						if (!acc_index.nil?)
							elemet_json=JSON.parse(x)
							full_file_name=elemet_json["full_file_name"]
							break;
						end	
					end
					if File.exist?(full_file_name)
						response.write(File.size(full_file_name))
					else
						response.write(0)
					end
				end	
				explorer_upload_files_acc=Array.new
				if(session[:explorer_upload_files].nil?)
					session[:explorer_upload_files]=Array.new
				end
				path='./public/assets/upload/ckeditor/'
				file_name='acronis_media.iso'
				full_file_name=path+file_name
				explorer_upload_files_acc.insert(-1,JSON.parse('{"'+file_name+'":"'+full_file_name+'"}'))
				session[:explorer_upload_files].insert(-1,JSON.parse('{"'+file_name+'":"'+full_file_name+'"}'))
				full_file_name=path+explorer_upload_files_acc.to_json[file_name]
			end 
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