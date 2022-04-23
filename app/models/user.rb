class User < ApplicationRecord
  validates :email, presence: true
  validates :pw_digest, presence: true
end
