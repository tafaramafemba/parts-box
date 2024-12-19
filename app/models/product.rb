class Product < ApplicationRecord
  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: :user_id
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id", optional: true
  has_one_attached :image
  has_many_attached :additional_images
  has_many :carts
  has_and_belongs_to_many :orders
  has_many :order_items


  # validates :make, presence: true
  # validates :model, presence: true
  # validates :year, format: { with: /\A\d{4}\z/, message: "must be a valid year" }, allow_blank: true
  # validates :price, numericality: { greater_than_or_equal_to: 0 }
  # validates :location, presence: true
  # validates :description, presence: true, length: { minimum: 10 }
  # validates :condition, inclusion: { in: %w(new used), message: "%{value} is not a valid condition" }, presence: true

end
