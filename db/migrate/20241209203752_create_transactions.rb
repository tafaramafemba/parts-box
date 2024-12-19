class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :trade_item, null: false, foreign_key: true
      t.decimal :cash_top_up
      t.decimal :platform_fee

      t.timestamps
    end
  end
end
