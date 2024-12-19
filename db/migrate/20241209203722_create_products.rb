class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :barter_terms
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
