class AddPublishedToBlogPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :blog_posts, :published, :boolean
  end
end
