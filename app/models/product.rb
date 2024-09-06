class Product < ApplicationRecord
  has_many :orders
  has_many :users, through: :orders

  validates :code, presence: true

  def self.find_or_create(code:)
    Product.find_by_code(code) || Product.create!(code: code)
  end
end
