class AddShippingAddressIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :shipping_address, null: false, foreign_key: true
  end
end
