class Review < ApplicationRecord
  belongs_to :user
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { maximum: 500 }
end
