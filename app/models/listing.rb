class Listing < ApplicationRecord
    has_many :requests

    validates :name, presence: true
    validates :pick_up_location, presence: true
    validates :rental_fee, presence: true
    validates :rental_fee_unit, presence: true
    validates :rental_fee_time, presence: true
    validates :deposit_amount, presence: true

    enum rental_fee_unit: [:karma, :dollars]
    enum rental_fee_time: [:hour, :day, :week]
end
