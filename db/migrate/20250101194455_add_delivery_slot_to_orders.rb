class AddDeliverySlotToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :delivery_slot, :datetime
  end
end
