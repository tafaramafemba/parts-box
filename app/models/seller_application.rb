class SellerApplication < ApplicationRecord
  belongs_to :user
  has_one_attached :id_document
  has_one_attached :business_registration_document

  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true 
  validates :address, presence: true
  validates :business_registration_number, uniqueness: true
end
