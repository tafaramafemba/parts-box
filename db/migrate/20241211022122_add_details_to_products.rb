class AddDetailsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :make, :string
    add_column :products, :model, :string
    add_column :products, :year, :string
    add_column :products, :manufacturer_part_number, :string
  end
end
