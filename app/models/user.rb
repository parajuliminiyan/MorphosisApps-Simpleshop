class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :user_type, presence: true

  def isAdmin?
    user_type == 1
  end

  def isCustomer?
    user_type == 2
  end

  def isAdminandCustomer?
    user_type == 3
  end
end
