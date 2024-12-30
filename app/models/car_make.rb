class CarMake < ApplicationRecord
  has_many :car_models

  validates :name, presence: true, uniqueness: true
end
