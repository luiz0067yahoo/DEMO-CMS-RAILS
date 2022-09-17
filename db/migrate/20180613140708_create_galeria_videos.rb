class CreateGaleriaVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :galeria_videos do |t|
      t.string :nome
      t.string :descricao
      t.string :link_youtube
      t.references :Menu, foreign_key: true

      t.timestamps
    end
  end
end
