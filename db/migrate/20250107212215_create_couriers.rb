class CreateCouriers < ActiveRecord::Migration[7.2]
  def change
    create_table :couriers do |t|
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
