FactoryBot.define do
  factory :rental do
    status { 1 }
    renter { request.requester }
    association :listing_id, factory: :listing
    association :request_id, factory: :rental_request
  end
end
