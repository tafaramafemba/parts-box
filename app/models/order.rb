require 'csv'

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :courier, optional: true
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :products
  belongs_to :shipping_address

  validates :user_id, presence: true
  validates :shipping_address_id, presence: true

  enum status: { pending: 'pending', collected: 'collected', not_collected: 'not_collected', dispatched: 'dispatched', delivered: 'delivered', cancelled: 'cancelled', delivery_failed: 'delivery_failed' }

  # before_create :assign_delivery_slot
  before_create :assign_collection_time

  def self.to_csv
    attributes = %w{
      delivery_slot order_id customer_name phone_number delivery_address product_name quantity seller_name seller_address
    }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.includes(:user, :shipping_address, order_items: { product: :user }).each do |order|
        order.order_items.each do |item|
          seller_information = SellerInformation.find_by(user_id: item.product.user.id)
          csv << [
            order.delivery_slot.strftime("%H:%M"),
            order.id,
            "#{order.user.first_name} #{order.user.last_name}",
            "\t#{order.user.phone_number}",  # Prepend with a tab character to treat as text
            "#{order.shipping_address.address_line1}, #{order.shipping_address.address_line2}, #{order.shipping_address.city}, #{order.shipping_address.state}",
            "#{item.product.name} (#{item.product.make} #{item.product.model} #{item.product.year})",
            item.quantity,
            seller_information.business_name,
            seller_information.address,
          ]
        end
      end
    end
  end

  def self.to_csv_for_slot(slot_time)
    attributes = %w{
      delivery_slot order_id customer_name phone_number delivery_address product_name quantity seller_name seller_address
    }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      where("strftime('%H:%M', delivery_slot) = ?", slot_time).includes(:user, :shipping_address, order_items: { product: :user }).each do |order|
        order.order_items.each do |item|
          seller_information = SellerInformation.find_by(user_id: item.product.user.id)
          csv << [
            order.delivery_slot.strftime("%H:%M"),
            order.id,
            "#{order.user.first_name} #{order.user.last_name}",
            "\t#{order.user.phone_number}",  # Prepend with a tab character to treat as text
            "#{order.shipping_address.address_line1}, #{order.shipping_address.address_line2}, #{order.shipping_address.city}",
            "#{item.product.name} (#{item.product.make} #{item.product.model} #{item.product.year})",
            item.quantity,
            seller_information.business_name,
            seller_information.address,
          ]
        end
      end
    end
  end

  def user_email
    user.email
  end

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

  def assign_collection_time
    self.collection_time = Time.current + 3.hours
    if self.collection_time.hour >= 16 && self.collection_time.min >= 30
      self.collection_time = self.collection_time.change(hour: 9, min: 0) + 1.day
    elsif self.collection_time.hour < 9
      self.collection_time = self.collection_time.change(hour: 9, min: 0)
    end
  end
end