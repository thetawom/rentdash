require "rails_helper"

RSpec.describe ListingReview, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      review = ListingReview.create(review: "This is so awesome!")
      expect(review.valid?).to eq false
      expect(review.errors[:review]).to be_empty
      expect(review.errors[:rating]).to_not be_empty
      expect(review.errors[:listing]).to_not be_empty
      expect(review.errors[:reviewer]).to_not be_empty
    end
    it "should return false when rating is less than 1" do
      review = FactoryBot.create(:listing_review)
      review.update(rating: 0)
      expect(review.valid?).to eq false
    end
    it "should return false when rating is greater than 5" do
      review = FactoryBot.create(:listing_review)
      review.update(rating: 6)
      expect(review.valid?).to eq false
    end
  end

end
