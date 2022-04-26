class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password
end
