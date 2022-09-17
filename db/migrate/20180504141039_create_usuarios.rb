class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :login
      t.string :senha
      t.string :email
	  t.integer :tentativas_falhadas,default: 0
	  t.boolean :inativo,default: true
		
      t.timestamps
    end
    add_index :usuarios, :id
    add_index :usuarios, :inativo
    add_index :usuarios, :nome
    add_index :usuarios, :login
  end
end
