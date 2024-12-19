class AddSellerStatusToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :seller_status, :string, default: "not_applied"
  end
end
