class CreateBlogPosts < ActiveRecord::Migration[7.2]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :content
      t.string :author
      t.date :published_date

      t.timestamps
    end
  end
end
