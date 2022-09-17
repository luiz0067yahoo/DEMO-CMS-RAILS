class AddAttachmentFotoToNoticiaFotos < ActiveRecord::Migration[5.2]
  def self.up
    change_table :noticia_fotos do |t|
      t.attachment :foto
    end
  end

  def self.down
    remove_attachment :noticia_fotos, :foto
  end
end
