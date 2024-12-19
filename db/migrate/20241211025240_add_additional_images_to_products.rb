class AddAdditionalImagesToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :additional_images, :json, default: []
  end
end
