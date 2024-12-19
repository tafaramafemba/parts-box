class TradeRequest < ApplicationRecord
  belongs_to :product
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  has_many_attached :images
end
