class CreateCategoryShippingFees < ActiveRecord::Migration[7.2]
  def change
    create_table :category_shipping_fees do |t|
      t.string :category
      t.decimal :fee

      t.timestamps
    end
  end
end
