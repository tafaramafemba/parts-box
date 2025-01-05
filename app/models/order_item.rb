class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :order_id, presence: true
  validates :product_id, presence: true

  def calculate_commission_fee
    commission_fee_percentage = CommissionFee.first&.percentage || 0.05
    fee = self.product.price * self.quantity * commission_fee_percentage
    fee.round(0)
  end

  def amount_due_to_seller
    self.product.price * self.quantity - calculate_commission_fee
  end

end