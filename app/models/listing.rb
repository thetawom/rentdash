class Listing < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_many :rental_requests

    validates :name, presence: true
    validates :pick_up_location, presence: true
    validates :fee, presence: true
    validates :fee_unit, presence: true
    validates :fee_time, presence: true
    validates :deposit, presence: true

    enum fee_unit: [:karma, :dollars]
    enum fee_time: [:hour, :day, :week]

    def owner
        User.find_by id: owner_id
    end

end
