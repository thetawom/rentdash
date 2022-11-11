class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"

    validates :pick_up_date, presence: true
    validates :return_date, presence: true

    def to_rental(payment_method = nil)
        Rental.create(listing: listing, request: self, renter: requester, status: :upcoming, payment_method: payment_method)
    end

end
