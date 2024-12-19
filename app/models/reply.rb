class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :blog_post

  validates :content, presence: true  # Optional: validate the reply content
  validates :user_name, presence: true  # Optional: validate the user name
end
