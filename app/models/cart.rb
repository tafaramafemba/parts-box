class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def total_price
    product.price * quantity
  end

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
