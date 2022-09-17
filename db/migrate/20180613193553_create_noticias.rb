class CreateNoticias < ActiveRecord::Migration[5.2]
  def change
    create_table :noticias do |t|
      t.string :titulo
      t.string :subtitulo
      t.string :fonte
      t.binary :conteudo
      t.boolean :ocultar
      t.references :Menu, foreign_key: true

      t.timestamps
    end
  end
end
