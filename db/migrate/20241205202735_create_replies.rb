class CreateReplies < ActiveRecord::Migration[7.2]
  def change
    create_table :replies do |t|
      t.text :content
      t.string :user_name
      t.references :comment, null: false, foreign_key: true
      t.references :blog_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
