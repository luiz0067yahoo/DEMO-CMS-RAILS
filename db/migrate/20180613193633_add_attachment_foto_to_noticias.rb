class AddAttachmentFotoToNoticias < ActiveRecord::Migration[5.2]
  def self.up
    change_table :noticias do |t|
      t.attachment :foto
    end
  end

  def self.down
    remove_attachment :noticias, :foto
  end
end
