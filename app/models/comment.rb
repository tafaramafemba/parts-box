class Comment < ApplicationRecord
  belongs_to :blog_post
  belongs_to :parent_comment, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  validates :user_name, :content, presence: true

  def likes_count
    comment_likes.count
  end
end


