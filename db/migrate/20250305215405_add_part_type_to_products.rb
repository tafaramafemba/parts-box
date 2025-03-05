class AddPartTypeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :part_type, :string, default: 'aftermarket'
  end
end
