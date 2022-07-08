class User < ApplicationRecord
  has_paper_trail
  has_secure_password

  has_many :logins

  validates :email, presence: true,
                    format: /\A\S+@\S+\z/,
                    uniqueness: { case_sensitive: false }

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 15 }
end
