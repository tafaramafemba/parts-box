class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.integer :buyer_id, null: false
      t.integer :seller_id, null: false
      t.integer :product_id, null: false
      t.timestamps
    end
  end
end
