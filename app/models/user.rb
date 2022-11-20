class User < ApplicationRecord
  has_many :listings, foreign_key: "owner_id", dependent: :destroy
  has_many :rental_requests, foreign_key: "requester_id", dependent: :destroy
  has_many :rentals, foreign_key: "renter_id", dependent: :destroy
  has_many :listing_reviews, foreign_key: "reviewer_id", dependent: :destroy

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