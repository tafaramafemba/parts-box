class CreatePayoutTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :payout_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
