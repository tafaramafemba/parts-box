class SellerInformation < ApplicationRecord
  belongs_to :user
  has_one_attached :id_document
  has_one_attached :business_registration_document
end
