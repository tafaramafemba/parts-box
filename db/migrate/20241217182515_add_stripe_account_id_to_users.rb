class AddStripeAccountIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :stripe_account_id, :string
  end
end
