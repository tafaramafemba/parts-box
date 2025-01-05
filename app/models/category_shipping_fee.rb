class CategoryShippingFee < ApplicationRecord
    validates :category, presence: true, uniqueness: true
    validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end