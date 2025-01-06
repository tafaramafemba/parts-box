class RemovePostalCodeAndCountryFromShippingAddress < ActiveRecord::Migration[7.2]
  def change
    remove_column :shipping_addresses, :postal_code, :string
    remove_column :shipping_addresses, :country, :string
  end
end
