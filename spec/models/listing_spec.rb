require 'rails_helper'

RSpec.describe Listing, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      @listing = Listing.create(name: "LEGO Creator Expert 10276 Colosseum")
      expect(@listing.valid?).to eq false
      expect(@listing.errors[:name]).to be_empty
      expect(@listing.errors[:owner]).to_not be_empty
      expect(@listing.errors[:pick_up_location]).to_not be_empty
      expect(@listing.errors[:fee]).to_not be_empty
      expect(@listing.errors[:fee_unit]).to_not be_empty
      expect(@listing.errors[:fee_time]).to_not be_empty
      expect(@listing.errors[:deposit]).to_not be_empty
    end
  end

  describe "#owner" do
    let(:user) { FactoryBot.create(:user) }
    it "should find the user instance for the owner by id" do
      allow(User).to receive(:find_by).with(id: 1).and_return(user)
      @listing = Listing.create(name: "LEGO Creator Expert 10276 Colosseum", owner: user)
      expect(@listing.owner).to eq user
    end
  end

end
