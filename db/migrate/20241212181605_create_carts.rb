class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, default: 1, null: false

      t.timestamps
    end

    add_index :carts, :user_id
    add_index :carts, :product_id
  end
end
