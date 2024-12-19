class CreateCarModels < ActiveRecord::Migration[7.2]
  def change
    create_table :car_models do |t|
      t.string :name
      t.references :car_make, null: false, foreign_key: true

      t.timestamps
    end
  end
end
