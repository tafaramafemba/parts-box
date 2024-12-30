class AddListingStatusToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :listing_status, :boolean, default: true
  end
end
