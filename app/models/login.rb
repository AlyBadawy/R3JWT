class Login < ApplicationRecord
  belongs_to :user

  validates :jwt, presence: true
  validates :refresh_token, presence: true
  validates :logged_out, presence: true
end
