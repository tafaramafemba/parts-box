class CreateCarParts < ActiveRecord::Migration[7.2]
  def change
    create_table :car_parts do |t|
      t.string :name
      t.text :description
      t.text :tools
      t.decimal :labor_cost

      t.timestamps
    end
  end
end
