class AddStatusToSellerInformation < ActiveRecord::Migration[7.2]
  def change
    add_column :seller_informations, :status, :string, default: "active"
  end
end
