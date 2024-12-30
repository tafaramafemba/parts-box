class CarPart < ApplicationRecord
  belongs_to :car_model
  belongs_to :car_make

  validates :name, presence: true
  validates :car_model_id, presence: true
  validates :car_make_id, presence: true
end
