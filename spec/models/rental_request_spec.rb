require "rails_helper"

RSpec.describe RentalRequest, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      rental_request = RentalRequest.create(pick_up_time: DateTime.now, return_time: DateTime.now + 1.hour)
      expect(rental_request.valid?).to eq false
      expect(rental_request.errors[:return_time]).to be_empty
      expect(rental_request.errors[:pick_up_time]).to be_empty
      expect(rental_request.errors[:payment_method]).to_not be_empty
    end
    it "should return false when pick-up time is before current time" do
      rental_request = RentalRequest.create(pick_up_time: DateTime.now - 1.hour, return_time: DateTime.now + 1.hour, payment_method: "paypal")
      expect(rental_request.valid?).to eq false
      expect(rental_request.errors[:return_time]).to be_empty
      expect(rental_request.errors[:pick_up_time]).to_not be_empty
      expect(rental_request.errors[:payment_method]).to be_empty
    end
    it "should return false when return time is before pick-up time" do
      rental_request = RentalRequest.create(pick_up_time: DateTime.now + 2.hour, return_time: DateTime.now + 1.hour, payment_method: "paypal")
      expect(rental_request.valid?).to eq false
      expect(rental_request.errors[:return_time]).to_not be_empty
      expect(rental_request.errors[:pick_up_time]).to be_empty
      expect(rental_request.errors[:payment_method]).to be_empty
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
