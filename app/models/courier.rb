class Courier < ApplicationRecord
    has_many :orders
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :phone_number, presence: true, uniqueness: true
end
