class Product < ApplicationRecord
  if Rails.env.production?
    include PgSearch::Model
    pg_search_scope :search_by_name, 
                    against: :name, 
                    using: {
                      tsearch: { prefix: true }, # Full-text search with partial matches
                      trigram: { threshold: 0.2 } # Fuzzy search with trigram similarity
                    }
    pg_search_scope :search_by_make, 
                    against: :make, 
                    using: {
                      tsearch: { prefix: true },
                      trigram: { threshold: 0.2 }
                    }
    pg_search_scope :search_by_model, 
                    against: :model, 
                    using: {
                      tsearch: { prefix: true },
                      trigram: { threshold: 0.2 }
                    }
  else
    scope :search_by_name, ->(query) { where("name LIKE ?", "%#{query}%") }
    scope :search_by_make, ->(query) { where("make LIKE ?", "%#{query}%") }
    scope :search_by_model, ->(query) { where("model LIKE ?", "%#{query}%") }
  end

  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: :user_id
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id", optional: true
  has_one_attached :image
  has_many_attached :additional_images
  has_many :carts
  has_and_belongs_to_many :orders
  has_many :order_items


  validates :make, presence: true
  validates :model, presence: true
  validates :year, format: { with: /\A\d{4}\z/, message: "must be a valid year" }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  private

  def acceptable_image
    return unless image.attached?
    
    # Limit file size
    if image.byte_size > 5.megabytes
      errors.add(:image, "must be less than 5MB")
    end
    
    # Limit dimensions
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be JPEG or PNG")
    end
  end

end
