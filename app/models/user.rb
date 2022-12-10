class User < ApplicationRecord
  has_many :listings, foreign_key: "owner_id", dependent: :destroy
  has_many :rental_requests, foreign_key: "requester_id", dependent: :destroy
  has_many :rentals, foreign_key: "renter_id", dependent: :destroy
  has_many :listing_reviews, foreign_key: "reviewer_id", dependent: :destroy

  has_secure_password

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.karma = 20
  end

  def welcome
    "Hello, #{first_name}!"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def add_karma(cost)
    update karma: karma + cost
  end
  def deduct_karma(cost)
    update karma: karma - cost
  end

end