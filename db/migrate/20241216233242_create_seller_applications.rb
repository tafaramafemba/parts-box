class CreateSellerApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :seller_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :id_document
      t.string :address
      t.string :business_name
      t.string :business_registration_number
      t.string :business_registration_document
      t.string :status

      t.timestamps
    end
  end
end
