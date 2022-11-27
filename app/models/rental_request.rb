class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"
    has_one :rental, foreign_key: "request_id", dependent: :destroy

    validates :status, presence: true
    validates :pick_up_time, presence: true
    validates :return_time, presence: true
    validates_comparison_of :return_time, greater_than_or_equal_to: :pick_up_time
    validates_comparison_of :pick_up_time, greater_than_or_equal_to: Date.today

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
