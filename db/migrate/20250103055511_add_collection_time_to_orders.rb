class AddCollectionTimeToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :collection_time, :time
  end
end
