class AddLikesCountToBlogPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :blog_posts, :likes_count, :integer, default: 0
  end
end
