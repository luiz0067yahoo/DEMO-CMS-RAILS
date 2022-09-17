# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_10_164533) do

  create_table "galeria_fotos", force: :cascade do |t|
    t.string "nome"
    t.string "descricao"
    t.integer "Menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto_file_name"
    t.string "foto_content_type"
    t.bigint "foto_file_size"
    t.datetime "foto_updated_at"
    t.index ["Menu_id"], name: "index_galeria_fotos_on_Menu_id"
  end

  create_table "galeria_videos", force: :cascade do |t|
    t.string "nome"
    t.string "descricao"
    t.string "link_youtube"
    t.integer "Menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Menu_id"], name: "index_galeria_videos_on_Menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "nome"
    t.string "link"
    t.integer "pai_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "noticia_fotos", force: :cascade do |t|
    t.string "nome"
    t.string "descricao"
    t.integer "Noticia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto_file_name"
    t.string "foto_content_type"
    t.bigint "foto_file_size"
    t.datetime "foto_updated_at"
    t.index ["Noticia_id"], name: "index_noticia_fotos_on_Noticia_id"
  end

  create_table "noticia_videos", force: :cascade do |t|
    t.string "nome"
    t.string "descricao"
    t.string "link_youtube"
    t.integer "Noticia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Noticia_id"], name: "index_noticia_videos_on_Noticia_id"
  end

  create_table "noticias", force: :cascade do |t|
    t.string "titulo"
    t.string "subtitulo"
    t.string "fonte"
    t.binary "conteudo"
    t.boolean "ocultar"
    t.integer "Menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto_file_name"
    t.string "foto_content_type"
    t.bigint "foto_file_size"
    t.datetime "foto_updated_at"
    t.index ["Menu_id"], name: "index_noticias_on_Menu_id"
  end

  create_table "perfis", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfis_usuarios", force: :cascade do |t|
    t.integer "Perfil_id"
    t.integer "Usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Perfil_id"], name: "index_perfis_usuarios_on_Perfil_id"
    t.index ["Usuario_id"], name: "index_perfis_usuarios_on_Usuario_id"
  end

  create_table "politicas", force: :cascade do |t|
    t.boolean "ver"
    t.boolean "editar"
    t.boolean "novo"
    t.boolean "salvar"
    t.boolean "excluir"
    t.boolean "atualizar"
    t.integer "Perfil_id"
    t.integer "Menu_id"
    t.integer "Sistema_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Menu_id"], name: "index_politicas_on_Menu_id"
    t.index ["Perfil_id"], name: "index_politicas_on_Perfil_id"
    t.index ["Sistema_id"], name: "index_politicas_on_Sistema_id"
  end

  create_table "sistemas", force: :cascade do |t|
    t.string "nome"
    t.string "path"
    t.boolean "permisao_por_menu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome"
    t.string "login"
    t.string "senha"
    t.string "email"
    t.integer "tentativas_falhadas", default: 0
    t.boolean "inativo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto_file_name"
    t.string "foto_content_type"
    t.bigint "foto_file_size"
    t.datetime "foto_updated_at"
    t.index ["id"], name: "index_usuarios_on_id"
    t.index ["inativo"], name: "index_usuarios_on_inativo"
    t.index ["login"], name: "index_usuarios_on_login"
    t.index ["nome"], name: "index_usuarios_on_nome"
  end

end
