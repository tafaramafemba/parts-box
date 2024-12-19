class AddReadToTradeRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :trade_requests, :read, :boolean
    add_column :trade_requests, :default, :string
    add_column :trade_requests, :false, :string
  end
end
