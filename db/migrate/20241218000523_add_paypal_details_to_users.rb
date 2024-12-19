class AddPaypalDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :paypal_email, :string
    add_column :users, :paypal_merchant_id, :string
    add_column :users, :paypal_access_token, :string
    add_column :users, :paypal_refresh_token, :string
  end
end
