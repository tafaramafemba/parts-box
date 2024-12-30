class SellerInformation < ApplicationRecord
  belongs_to :user
  has_one_attached :id_document
  has_one_attached :business_registration_document

  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :id_document, presence: true
  validates :address, presence: true
  validates :status, presence: true
end
