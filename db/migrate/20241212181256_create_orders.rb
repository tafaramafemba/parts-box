class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.decimal :shipping_fee, precision: 10, scale: 2, null: false
      t.decimal :platform_fee, precision: 10, scale: 2, null: false
      t.string :status, default: "pending", null: false

      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :product_id
  end
end
