class DeliverySlot < ApplicationRecord
    validates :time, presence: true
    validates :cutoff, presence: true
  end