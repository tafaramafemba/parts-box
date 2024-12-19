class ShippingAddress < ApplicationRecord
  belongs_to :user
  validates :address_line1, :city, :state, :postal_code, :country, presence: true
end
