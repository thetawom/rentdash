require "rails_helper"

RSpec.describe Rental, type: :model do

  describe "#validate" do
    let(:user) { FactoryBot.create(:user) }
    it "should return false when renter and requester are different" do
      request = FactoryBot.create(:rental_request)
      rental = Rental.create(request: request, listing: request.listing, renter: user)
      expect(rental.valid?).to eq false
      expect(rental.errors[:listing]).to be_empty
      expect(rental.errors[:renter]).to_not be_empty
    end
    it "should return false when listing and requested listing are different" do
      listing = FactoryBot.create(:listing)
      request = FactoryBot.create(:rental_request, requester: user)
      rental = Rental.create(request: request, listing: listing, renter: user)
      expect(rental.valid?).to eq false
      expect(rental.errors[:renter]).to be_empty
      expect(rental.errors[:listing]).to_not be_empty
    end
  end

  describe "#cancel" do
    let(:owner) { FactoryBot.create(:user, karma: 1000) }
    let(:renter) { FactoryBot.create(:user, karma: 1000) }
    let(:listing) { FactoryBot.create(:listing, owner: owner, fee_unit: "karma") }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: renter) }
    let!(:rental) { request.approve }
    it "should update rental status to cancelled" do
      expect(rental).to receive(:update).with(status: "cancelled")
      rental.cancel
    end
    it "should transfer karma from the listing owner to the renter if the fee unit is karma" do
      expect(renter).to receive(:add_karma).with(request.cost)
      expect(owner).to receive(:deduct_karma).with(request.cost)
      rental.cancel
    end
    it "should not transfer karma if the fee unit is dollars" do
      listing.update fee_unit: "dollars"
      expect(renter).to_not receive(:add_karma)
      expect(owner).to_not receive(:deduct_karma)
      rental.cancel
    end
  end

end
