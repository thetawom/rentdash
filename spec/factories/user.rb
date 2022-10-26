FactoryBot.define do

  sequence :email do |n|
    "uni#{n}@columbia.com"
  end

  factory :user do
    email
    first_name { "Frankie" }
    last_name { "Valli" }
    password { "password" }
  end
end