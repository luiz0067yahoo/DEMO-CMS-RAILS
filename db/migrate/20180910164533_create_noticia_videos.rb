class CreateNoticiaVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :noticia_videos do |t|
      t.string :nome
      t.string :descricao
      t.string :link_youtube
      t.references :Noticia, foreign_key: true

      t.timestamps
    end
  end
end
