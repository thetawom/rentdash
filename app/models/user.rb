class User < ApplicationRecord
  has_many :listings, foreign_key: "owner_id"

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  def welcome
    "Hello, #{first_name}!"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end