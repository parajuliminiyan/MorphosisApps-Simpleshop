class Order < ApplicationRecord
  has_many :product_orders
  has_many :product, through: :product_orders
end
