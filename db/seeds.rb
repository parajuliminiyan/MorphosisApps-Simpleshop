# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
require 'faker'
#User types
# 1-Admin
# 2-Customer
# 3-Both
users_list = [
  ["Hary Styles", "hary@abc.com", "hary123", 2], # username, email, password, type
  ["Taylor Swift", "taylor@abc.com", "taylor123", 3],
  ["Miniyan", "miniyan@gmail.com", "admin123", 1],
  ["Kali", "kali@gmail.com", "kali123", 2],
  ["Manoj", "manoj@gmail.com", "manoj123", 3]
]
# users_list.each { |name,email,password,type|
#   User.create(name: name, email:email, password: password, user_type: type)
# }
#
#
# 10.times do |i|
#   @regions = Region.create(title:Faker::Address.city, country:Faker::Address.country, currency:Faker::Currency.unique.code, tax:rand(1.0..9.5))
#   Product.create(title:Faker::Commerce.product_name, description:Faker::Lorem.sentence(word_count: 10), img_url:Faker::LoremFlickr.image(size: "200x300", search_terms: ['Products']), price:Faker::Commerce.price, sku:SecureRandom.hex(4), stock:rand(0..100), regions_id: @regions.id)
#
# end

# 10.times do |i|
#   Product.create(title:Faker::Commerce.product_name, description:Faker::Lorem.sentence(word_count: 10), img_url:Faker::LoremFlickr.image(size: "200x300", search_terms: ['Products']), price:Faker::Commerce.price, sku:SecureRandom.hex(4), stock:rand(0..100))
# end

10.times do |i|
  @order =  Order.create(customer_name:Faker::Name.name, shipping_address:Faker::Address.full_address, order_total:Faker::Commerce.price , paid_at:Time.now, user_id:1)
  @product = Product.create(title:Faker::Commerce.product_name, description:Faker::Lorem.sentence(word_count: 10), img_url:Faker::LoremFlickr.image(size: "200x300", search_terms: ['Products']), price:Faker::Commerce.price, sku:SecureRandom.hex(4), stock:rand(0..100),regions_id: 2)
  ProductOrder.create(product_id:@product.id, order_id:@order.id)
end
