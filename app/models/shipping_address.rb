class ShippingAddress < ApplicationRecord
  belongs_to :user
  validates :address_line1, :city, :state, presence: true
end
