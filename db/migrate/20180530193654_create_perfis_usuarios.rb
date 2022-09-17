class CreatePerfisUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :perfis_usuarios do |t|
      t.references :Perfil, foreign_key: true
      t.references :Usuario, foreign_key: true

      t.timestamps
    end
  end
end
