require 'rails_helper'

RSpec.describe User, type: :model do
  it 'return true if user is admin' do
    user = User.new(name: "TestUser", email: "test@test.com", password_digest: "test123", user_type: 1)
    expect(user.isAdmin?).to eq(true)
    expect(user.isCustomer?).to eq(false)
  end

  it 'return true if user is customer' do
    user = User.new(name: "TestUser", email: "test@test.com", password_digest: "test123", user_type: 2)
    expect(user.isAdmin?).to eq(false)
    expect(user.isCustomer?).to eq(true)
  end
  it 'return true if user is both customer and admin' do
    user = User.new(name: "TestUser", email: "test@test.com", password_digest: "test123", user_type: 3)
    expect(user.isAdminandCustomer?).to eq(true)
  end

  describe "Validations" do
    it 'email is unique' do
      email = "test@test.com"
      User.new(name: "TestUser", email: email, password_digest: "test123", user_type: 2).save
      user = User.new(name: "TestUser", email: email, password_digest: "test123", user_type: 2)
      user.save
      expect(user).to_not be_valid
    end
  end
end