class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"

    validates :pick_up_date, presence: true
    validates :return_date, presence: true

end
