FactoryBot.define do
  factory :rental do
    payment_method { 1 }
    status { 1 }
    listing_id { nil }
    request_id { nil }
    renter { nil }
  end
end
