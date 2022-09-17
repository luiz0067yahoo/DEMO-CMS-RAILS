json.extract! noticia, :id, :titulo, :subtitulo, :fonte, :conteudo, :ocultar, :Menu_id, :created_at, :updated_at
json.url noticia_url(noticia, format: :json)
