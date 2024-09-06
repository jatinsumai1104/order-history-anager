class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :products, through: :orders

  validates :email, presence: true, uniqueness: true
end
