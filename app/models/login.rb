class Login < ApplicationRecord
  belongs_to :user
  has_secure_password(:refresh_token)
end
