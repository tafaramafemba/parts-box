class AddPaypalPaymentIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :paypal_payment_id, :string
  end
end
