Rails.application.routes.draw do  
  match 'w2ui/index',                  to: 'w2ui#index'           , via: [:get, :post]        
  #match '/adm/:model/lib/*pages',              to: 'w2ui#file_assets'        , via: [:get, :post]
  #match '/adm/:model/:id/*pages',              to: 'w2ui#file_assets'        , via: [:get, :post]
  #match '/adm/:model/:action/*pages',          to: 'w2ui#file_assets'        , via: [:get, :post]
  #match '/adm/:model/:action/:id/*pages',      to: 'w2ui#file_assets'        , via: [:get, :post]
  scope '/adm' do
    get   '/acesso_restrito',                  to: 'adm#acesso_restrito'
    get   '/tempo_sessao',                     to: 'adm#tempo_sessao'       
    get   '/senha_trocada_com_sucesso',        to: 'adm#senha_trocada_com_sucesso'  
    match '/',                                 to: 'adm#login'            , via: [:get, :post]
    match '/painel',                           to: 'adm#painel'           , via: [:get, :post]
    match '/esqueceu_a_senha',                 to: 'adm#esqueceu_a_senha'     , via: [:get, :post]
    match '/codigo_verificacao',               to: 'adm#codigo_verificacao'     , via: [:get, :post]
    match '/trocar_senha',                     to: 'adm#trocar_senha'       , via: [:get, :post]
    match '/cadastre_se',                      to: 'adm#cadastre_se'        , via: [:get, :post]
  match '/politicas',                        to: 'politicas#index'        , via: [:get, :post]
  match '/perfis_usuarios',                  to: 'perfis_usuarios#index'      , via: [:get, :post]
    resources :usuarios
    resources :perfis
    resources :menus
    resources :sistemas
    resources :galeria_fotos
    resources :galeria_videos
    resources :noticias
    resources :noticia_fotos
    resources :noticia_videos
  end
  match '*pages',                              to: 'w2ui#file_assets'				, via: [:get, :post]
end
