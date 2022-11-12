class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"
    has_one :rental, foreign_key: "request_id", dependent: :destroy

    validates :status, presence: true
    validates :pick_up_date, presence: true
    validates :return_date, presence: true

    enum status: {pending: 0, approved: 1, declined: 2}

    def approve
        self.status = :approved
        self.save
        Rental.create listing: listing, request: self, renter: requester, status: :upcoming
    end

    def decline
        self.status = :declined
        self.save
    end

end
