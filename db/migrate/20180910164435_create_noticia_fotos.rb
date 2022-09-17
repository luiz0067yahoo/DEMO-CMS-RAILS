class CreateNoticiaFotos < ActiveRecord::Migration[5.2]
  def change
    create_table :noticia_fotos do |t|
      t.string :nome
      t.string :descricao
      t.references :Noticia, foreign_key: true

      t.timestamps
    end
  end
end
