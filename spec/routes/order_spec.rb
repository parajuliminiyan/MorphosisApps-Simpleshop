require 'rails_helper'
RSpec.describe "Order Routes", type: :request do
  describe "Get /orders" do
    before do
      @token = login
      create_order(@token)
    end
    it 'should list all the Orders' do
      token = login
      get "/orders", headers: { Authorization: "Bearer #{token}" }
      expect(response.status).to eq(200)
    end
    it 'GET single Order' do
      get "/orders/#{Order.first.id}", headers: { Authorization: "Bearer #{@token}" }
      expect(response.status).to eq(200)
    end
  end
  describe "Post /orders" do
    before(:all) do
      @product = Product.where("stock > 0")
    end
    it 'Should create Order by customer' do
      token = login
      create_order(token)
      expect(response.status).to eql(200)

      #verify stock is decreased
      recentProduct = Product.find_by(id: @product.id)
      expect(recentProduct.stock + 1).to eq(@product.stock)
    end
    it 'create order by admin' do
      create_admin_user
      token = login_admin
      create_order(token)
      expect(response.status).to eql(401)

      #verify stock is not decreased
      recentProduct = Product.find_by(id: @product.id)
      expect(recentProduct.stock).to eq(@product.stock)
    end
  end
  describe "Update Orders" do
    it 'should update orders' do
      token = login
      create_order(token)
      put "/orders/#{Order.first.id}", params:{order: { customer_name: "user2", shipping_address: "Butwal" }},headers: { Authorization: "Bearer #{token}" }
      currentOrder = Order.find_by(id:Order.first.id)
      expect(response.status).to eql(204)
      expect(currentOrder.customer_name).to eq("user2")
      expect(currentOrder.shipping_address).to eq("Butwal")
    end
  end

  def create_admin_user
    @user = User.new(name: "Test Admin", email: "testadmin@test.com", password_digest: BCrypt::Password.create("admin"), user_type: 1)
    @user.save
  end

  def login_admin
    post "/user/login", params: { email: "testadmin@test.com", password: "admin123" }
    @token = JSON.parse(response.body)["token"]
  end

  def login
    post "/user/login", params: { email: "test@test.com", password: "test123" }
    @token = JSON.parse(response.body)["token"]
  end

  def create_admin_and_customer_user
    @user = User.new(name: "Customer Admin", email: "cusAdmin@test.com", password_digest: BCrypt::Password.create("cusAdmin123"), user_type: 3)
    @user.save
  end

  def login_admin_customner
    post "/user/login", params: { email: "cusAdmin@test.com", password: "cusAdmin123" }
    @token = JSON.parse(response.body)["token"]
  end

  def create_order(token)
    @product = Product.where("stock > 0").first
    post "/orders", params: { order: { customer_name: "user1", shipping_address: "Hetaudua" }, product_ids: [@product.id] }, headers: { Authorization: "Bearer #{token}" }
  end
end
