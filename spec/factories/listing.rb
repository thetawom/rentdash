FactoryBot.define do
  factory :listing do
    name { "Listed Item" }
    pick_up_location { "John Jay Hall" }
    fee { 1.00 }
    fee_unit { "karma" }
    fee_time { "hour" }
    deposit { 1.00 }
    item_category { "books" }
    venmo { true }
    association :owner, factory: :user
  end
end