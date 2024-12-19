class BlogPost < ApplicationRecord
  after_initialize :set_default_published, if: :new_record?
  has_many :likes, dependent: :destroy

  has_one_attached :cover_image
  has_many_attached :content_images
  has_many :comments, dependent: :destroy
  validates :title, :content, :author, :published_date, presence: true

  # validates :cover_image, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  # validates :content_images, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  def likes_count
    likes.count
  end

  # Increment the like count
  def increment_likes
    increment!(:likes_count)
  end

  # Decrement the like count
  def decrement_likes
    decrement!(:likes_count)
  end

  def set_default_published
    self.published = published_date.present? && published_date <= Date.today
  end

  # Scope for published posts
  scope :published, -> { where(published: true) }

end
