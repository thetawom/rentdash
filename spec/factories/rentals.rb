FactoryBot.define do
  factory :rental do
    payment_method { 1 }
    status { 1 }
    association :listing_id, factory: :listing
    association :request_id, factory: :rental_request
    association :renter_id, factory: :user
  end
end
