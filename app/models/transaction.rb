class Transaction < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'
  belongs_to :product
  belongs_to :trade_item, class_name: 'Product', optional: true

  validates :buyer_id, presence: true
  validates :seller_id, presence: true
  validates :product_id, presence: true
  validates :trade_item_id, presence: true, if: -> { trade_item.present? }
  validates :cash_top_up, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :platform_fee, numericality: { greater_than_or_equal_to: 0 }
end

