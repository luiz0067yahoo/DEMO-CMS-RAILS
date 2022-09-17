class CreateGaleriaFotos < ActiveRecord::Migration[5.2]
  def change
    create_table :galeria_fotos do |t|
      t.string :nome
      t.string :descricao
      t.references :Menu, foreign_key: true

      t.timestamps
    end
  end
end
