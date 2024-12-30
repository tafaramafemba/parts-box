class TradeRequest < ApplicationRecord
  belongs_to :product
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  has_many_attached :images

  validates :message, presence: true
  validates :cash_top_up, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :product_id, :sender_id, :recipient_id, presence: true
  validates :images, presence: true
  validates :name, :make, :model, :year, :manufacturer_part_number, :condition, :location, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1886 }
end
