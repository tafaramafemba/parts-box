class AddPaymentMethodToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :payment_method, :string, default: 'cod'
  end
end
