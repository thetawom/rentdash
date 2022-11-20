FactoryBot.define do
  factory :listing_review do
    rating { (1..5).to_a.sample }
    review { "#{%w[Awesome Competitive Charming Dazzling Excellent Incredible].sample} item!" }
    association :listing
    association :user
  end
end