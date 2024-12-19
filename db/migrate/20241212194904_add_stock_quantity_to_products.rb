class AddStockQuantityToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :stock_quantity, :integer
  end
end
