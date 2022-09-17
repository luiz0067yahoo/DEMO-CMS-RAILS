json.extract! noticia_video, :id, :nome, :descricao, :link_youtube, :Noticia_id, :created_at, :updated_at
json.url noticia_video_url(noticia_video, format: :json)
