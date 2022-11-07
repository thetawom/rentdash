FactoryBot.define do

  sequence :email do |n|
    "uni#{n}@columbia.com"
  end

  factory :user do
    email
    first_name { "Frankie" }
    last_name { "Valli" }
    password { "password" }

    factory :requester do
      first_name { "Nathan" }
      last_name { "Nguyen" }
      password { "asdfjkl;" }
    end

  end

  

end