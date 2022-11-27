require "rails_helper"

RSpec.describe Listing, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      listing = Listing.create(name: "LEGO Creator Expert 10276 Colosseum")
      expect(listing.valid?).to eq false
      expect(listing.errors[:name]).to be_empty
      expect(listing.errors[:owner]).to_not be_empty
      expect(listing.errors[:pick_up_location]).to_not be_empty
      expect(listing.errors[:fee]).to_not be_empty
      expect(listing.errors[:fee_unit]).to_not be_empty
      expect(listing.errors[:fee_time]).to_not be_empty
    end
    it "should return false when rental fee is negative" do
      listing = FactoryBot.create(:listing)
      listing.update(fee: -1)
      expect(listing.valid?).to eq false
    end
    it "should return false when deposit is negative" do
      listing = FactoryBot.create(:listing)
      listing.update(deposit: -1)
      expect(listing.valid?).to eq false
    end
    it "should return false when no accepted payment method is chosen" do
      listing = Listing.create(venmo: false, paypal: false, cash: false)
      expect(listing.valid?).to eq false
    end
  end

  describe "#rating" do
    let(:listing) { FactoryBot.create(:listing) }
    it "should return the average rating of all reviews" do
      [1, 4, 2, 4, 3].each do |rating|
        FactoryBot.create(:listing_review, listing: listing, rating: rating)
      end
      expect(listing.rating).to eq 2.8
    end
    it "should return nil when listing has no reviews" do
      expect(listing.rating).to be_nil
    end
  end

  describe "#accepted_payment_methods" do
    it "should return list only containing accepted payment methods" do
      listing = FactoryBot.create(:listing, venmo: true, paypal: true)
      methods = listing.accepted_payment_methods
      expect(methods).to include "venmo", "paypal"
      expect(methods).to_not include "cash"
    end
  end

end
