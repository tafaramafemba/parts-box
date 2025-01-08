class Courier < ApplicationRecord
    has_many :orders
    validates :name, presence: true
    validates :email, presence: true
    validates :phone_number, presence: true
end
