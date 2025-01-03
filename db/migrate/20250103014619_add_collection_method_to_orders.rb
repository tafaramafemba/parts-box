class AddCollectionMethodToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :collection_method, :string, default: 'pickup', null: false
  end
end
