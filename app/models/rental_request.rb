class RentalRequest < ApplicationRecord
    belongs_to :listing
    belongs_to :requester, class_name: "User"
end
