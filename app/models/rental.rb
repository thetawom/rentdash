class Rental < ApplicationRecord
  belongs_to :listing_id
  belongs_to :request_id
  belongs_to :renter
end
