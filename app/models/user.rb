class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :products, dependent: :destroy

  has_many :transactions_as_buyer, class_name: 'Transaction', foreign_key: :buyer_id, dependent: :destroy
  has_many :transactions_as_seller, class_name: 'Transaction', foreign_key: :seller_id, dependent: :destroy
       

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :blog_post
  has_many :comment_likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders
  has_many :carts
  has_one :shipping_address, dependent: :destroy
  accepts_nested_attributes_for :shipping_address
  has_one :seller_application, dependent: :destroy
  

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_one :seller_balance, dependent: :destroy # Ensure this association is correct


  def average_rating
    reviews.average(:rating).to_f.round(1) || 0.0
  end

end
