class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :blog_post, null: false, foreign_key: true
      t.string :user_name
      t.text :content

      t.timestamps
    end
  end
end
