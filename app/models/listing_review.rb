class ListingReview < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  validates :rating, presence: true, numericality: { in: 1..5 }

end
