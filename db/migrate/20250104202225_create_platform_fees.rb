class CreatePlatformFees < ActiveRecord::Migration[7.2]
  def change
    create_table :platform_fees do |t|
      t.decimal :percentage

      t.timestamps
    end
  end
end
