class CreateCommissionFees < ActiveRecord::Migration[7.2]
  def change
    create_table :commission_fees do |t|
      t.decimal :percentage

      t.timestamps
    end
  end
end
