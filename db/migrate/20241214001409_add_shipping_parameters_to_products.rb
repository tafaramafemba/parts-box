class AddShippingParametersToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :shipping_fee_type, :string, default: 'flat_rate' # flat_rate, calculated, free
    add_column :products, :flat_rate_shipping_fee, :decimal, default: 0.0
    add_column :products, :weight, :decimal
    add_column :products, :dimensions, :string # Stored as a JSON or serialized object: { length: 0, width: 0, height: 0 }
    add_column :products, :shipping_address, :text # Optional, in case the seller sets an address per product
  end
end
