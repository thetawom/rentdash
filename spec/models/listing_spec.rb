require 'rails_helper'

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
      expect(listing.errors[:deposit]).to_not be_empty
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
  end

end
