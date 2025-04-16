class AddReferenceAndPaynowPollUrlToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :reference, :string
    add_column :orders, :paynow_poll_url, :string
  end
end
