class CreatePoliticas < ActiveRecord::Migration[5.2]
  def change
    create_table :politicas do |t|
      t.boolean :ver
      t.boolean :editar
      t.boolean :novo
      t.boolean :salvar
      t.boolean :excluir
      t.boolean :atualizar
      t.references :Perfil, foreign_key: true
      t.references :Menu, foreign_key: true
      t.references :Sistema, foreign_key: true

      t.timestamps
    end
  end
end
