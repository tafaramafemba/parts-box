class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :products
  belongs_to :shipping_address

  validates :user_id, presence: true
  validates :shipping_address_id, presence: true

  enum status: { pending: 'pending', collected: 'collected', dispatched: 'dispatched', delivered: 'delivered', cancelled: 'cancelled' }

  before_create :assign_delivery_slot



  private

  def assign_delivery_slot
    current_time = Time.current
    delivery_slots = DeliverySlot.order(:time)

    slot = delivery_slots.find do |slot|
      cutoff_time = current_time.change(hour: slot.time.hour, min: slot.time.min) - slot.cutoff.hours
      Rails.logger.debug "Checking slot: #{slot.time}, cutoff_time: #{cutoff_time}, current_time: #{current_time}"
      current_time < cutoff_time
    end

    if slot
      self.delivery_slot = current_time.change(hour: slot.time.hour, min: slot.time.min)
      Rails.logger.debug "Assigned delivery slot: #{self.delivery_slot}"
    else
      next_day_slot = delivery_slots.first
      self.delivery_slot = (current_time + 1.day).change(hour: next_day_slot.time.hour, min: next_day_slot.time.min)
      Rails.logger.debug "Assigned next day delivery slot: #{self.delivery_slot}"
    end
  end
end
