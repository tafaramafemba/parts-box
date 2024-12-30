class CarModel < ApplicationRecord
  belongs_to :car_make

  validates :name, presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1886 }
end
