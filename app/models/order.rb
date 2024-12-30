class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :products
  belongs_to :shipping_address

  validates :user_id, presence: true
  validates :shipping_address_id, presence: true
  validates :order_items, presence: true
end
