class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"

    def findbylisting
        RentalRequest.find_by(listing_id: listingid)
    end

    def findbyUser
        RentalRequest.find_by(requester_id: requesterid)
    end
    
end
