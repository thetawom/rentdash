class Rental < ApplicationRecord
  belongs_to :listing
  belongs_to :request, class_name: "RentalRequest"
  belongs_to :renter, class_name: "User"

  validate :consistent_with_request

  def consistent_with_request
    errors.add(:listing, "must be same as requested listing") if listing_id != request.listing.id
    errors.add(:renter, "must be same as requester") if renter_id != request.requester.id
  end

end
