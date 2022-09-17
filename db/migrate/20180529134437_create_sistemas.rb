class CreateSistemas < ActiveRecord::Migration[5.2]
  def change
    create_table :sistemas do |t|
      t.string  :nome
      t.string  :path
      t.boolean :permisao_por_menu

      t.timestamps
    end
  end
end
