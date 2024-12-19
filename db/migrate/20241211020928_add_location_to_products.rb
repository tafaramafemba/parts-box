class AddLocationToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :location, :string, default: 'Canada'
  end
end
