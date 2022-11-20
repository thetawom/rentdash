class ListingReview < ApplicationRecord
  belongs_to :listing
  belongs_to :reviewer, class_name: "User"

  validates :rating, presence: true, numericality: { in: 1..5 }

end
