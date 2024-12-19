class AddConditionToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :condition, :string, default: "used"
  end
end
