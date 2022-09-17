class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :nome
      t.string :link
      t.integer :pai_id

      t.timestamps
    end
  end
end
