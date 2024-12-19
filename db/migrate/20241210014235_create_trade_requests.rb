class CreateTradeRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_requests do |t|
      t.text :message
      t.decimal :cash_top_up, precision: 10, scale: 2
      t.references :product, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.json :images, default: []
      t.timestamps
    end
  end
end
