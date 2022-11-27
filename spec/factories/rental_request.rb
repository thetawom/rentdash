FactoryBot.define do
    factory :rental_request do
      pick_up_time { DateTime.now + 1.day }
      return_time { DateTime.now + 2.day}
      payment_method { 1 }
      association :listing, factory: :listing
      association :requester, factory: :user
    end
end