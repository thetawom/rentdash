require 'rails_helper'

RSpec.describe RentalRequest, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      rental_request = RentalRequest.create(return_time: "2022-10-28 00:00:00 UTC")
      expect(rental_request.valid?).to eq false
      expect(rental_request.errors[:return_time]).to be_empty
      expect(rental_request.errors[:pick_up_time]).to_not be_empty
    end
  end

  describe "#approve" do
    let(:rental_request) {FactoryBot.create(:rental_request)}
    it "should create a rental object with consistent information" do
      rental = rental_request.approve
      expect(rental.valid?).to eq true
      expect(rental.request).to eq rental_request
      expect(rental.renter).to eq rental_request.requester
      expect(rental.listing).to eq rental_request.listing
      expect(rental.status).to eq "upcoming"
      expect(rental.payment_method).to be_nil
    end

    it "should mark the rental request as approved" do
      rental_request.approve
      expect(rental_request.status).to eq "approved"
    end
  end

  describe "#decline" do
    let(:rental_request) {FactoryBot.create(:rental_request)}
    it "should mark the rental request as declined" do
      rental_request.decline
      expect(rental_request.status).to eq "declined"
    end
  end

end
