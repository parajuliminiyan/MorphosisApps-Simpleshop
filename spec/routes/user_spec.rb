require 'rails_helper'

RSpec.describe "user Routes", type: :request do
  before(:all) do
    @user = User.new(name:"Test User",email: "test@test.com", password_digest: BCrypt::Password.create("test123"), user_type:2)
    @user.save
  end
  describe "Login  Route" do
    it 'should give token and user details after successful login' do

      post "/user/login", params:{email:@user.email, password: "test123"}
      responseJson = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(responseJson["token"]).to be_truthy
      expect(responseJson["user"]["name"]).to eq(@user.name)
      expect(responseJson["user"]["email"]).to eq(@user.email)
      expect(responseJson["user"]["user_type"]).to eq(@user.user_type)
    end

    it 'should give invalid email or password on wrong credentials' do

      post "/user/login", params:{email:@user.email, password: "test1223"}
      responseJson = JSON.parse(response.body)
      expect(response.status).to eq(401)
      expect(responseJson["error"]).to eq("Invalid email or password")
    end
  end

  describe "User/me Route" do
    it 'should give user details of current user on valid token'do
      post "/user/login", params:{email:"test@test.com", password: "test123"}
      token = JSON.parse(response.body)["token"]

      get "/user/details", headers:{Authorization: "Bearer "+ token}
      responseJson = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(responseJson["user"]["name"]).to eq(@user.name)
      expect(responseJson["user"]["email"]).to eq(@user.email)
      expect(responseJson["user"]["user_type"]).to eq(@user.user_type)
    end
    it 'should give error on invalid token'do
      token = "abcdefghijkl"
      get "/user/details", headers: { Authorization: "Bearer #{token}" }
      responseJson = JSON.parse(response.body)
      expect(response.status).to eq(401)
      expect(responseJson["errors"]).to eq("Invalid Token")
    end

  end


end