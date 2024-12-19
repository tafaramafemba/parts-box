class AddDetailsToTradeRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :trade_requests, :name, :string
    add_column :trade_requests, :make, :string
    add_column :trade_requests, :model, :string
    add_column :trade_requests, :year, :integer
    add_column :trade_requests, :manufacturer_part_number, :string
    add_column :trade_requests, :condition, :string, default: "used"
    add_column :trade_requests, :location, :string, default: 'Canada'
  end
end
