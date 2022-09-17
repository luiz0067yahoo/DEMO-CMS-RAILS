class AddAttachmentFotoToGaleriaFotos < ActiveRecord::Migration[5.2]
  def self.up
    change_table :galeria_fotos do |t|
      t.attachment :foto
    end
  end

  def self.down
    remove_attachment :galeria_fotos, :foto
  end
end
