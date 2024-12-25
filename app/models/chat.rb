class Chat < ApplicationRecord
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'
  belongs_to :product
  has_many :messages, dependent: :destroy

  def other_participant(current_user)
    current_user == seller ? buyer : seller
  end
  
end