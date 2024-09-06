class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, :product_id, :order_date, presence: true
end
