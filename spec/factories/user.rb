FactoryBot.define do

  sequence :email do |n|
    "uni#{n}@columbia.edu"
  end

  factory :user do
    email
    first_name { "Frankie" }
    last_name { "Valli" }
    password { "password" }
    phone { "1234567890" }
  end

end