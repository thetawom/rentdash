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

end
