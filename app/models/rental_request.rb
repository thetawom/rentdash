class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"
    has_one :rental, foreign_key: "request_id", dependent: :destroy

    validates :status, presence: true
    validates :payment_method, presence: true
    validates :pick_up_time, presence: true
    validates :return_time, presence: true
    validates_comparison_of :return_time, greater_than: :pick_up_time
    validates_comparison_of :pick_up_time, greater_than: DateTime.now

    enum status: {pending: 0, approved: 1, declined: 2}
    enum payment_method: {venmo: 0, paypal: 1, cash: 2}

    def approve
        self.status = :approved
        self.save
        rental = Rental.create listing: listing, request: self, renter: requester, status: :upcoming
        if listing.fee_unit == "karma"
            requester.deduct_karma cost
            listing.owner.add_karma cost
        end
        rental
    end

    def decline
        self.status = :declined
        self.save
    end

    def cost
        listing_fee_time = listing.fee_time
        listing_fee = listing.fee
        dt_return = return_time.to_datetime
        dt_pick_up = pick_up_time.to_datetime
        if listing_fee_time == 'hour'
            estimated_cost = ((dt_return - dt_pick_up)*24).ceil * listing_fee
        elsif listing_fee_time == 'day'
            estimated_cost = (dt_return - dt_pick_up).ceil * listing_fee
        elsif listing_fee_time == 'week'
            estimated_cost = ((dt_return - dt_pick_up)/7).ceil * listing_fee
        end
        estimated_cost
    end

end
