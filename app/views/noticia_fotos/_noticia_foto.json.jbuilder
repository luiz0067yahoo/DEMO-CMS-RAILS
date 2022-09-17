json.extract! noticia_foto, :id, :nome, :descricao, :Noticia_id, :created_at, :updated_at
json.url noticia_foto_url(noticia_foto, format: :json)
