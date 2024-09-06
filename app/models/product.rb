class Product < ApplicationRecord
  has_many :orders
  has_many :users, through: :orders

  validates :code, presence: true

  enum category: {
    'Electronics' => 0,
    'Clothing' => 1,
    'Home and Kitchen' => 2,
    'Books' => 3,
    'Beauty and Personal Care' => 4,
    'Sports and Outdoors' => 5,
    'Toys and Games' => 6,
    'Health and Wellness' => 7,
    'Tools and Home Improvement' => 8,
    'Office Products' => 9
  }

  def self.find_or_create(code:)
    Product.find_by_code(code) || Product.create!(code: code)
  end
end
