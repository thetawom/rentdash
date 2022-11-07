require 'rails_helper'

RSpec.describe RentalRequest, type: :model do

  describe "#validate" do
    it "should return false when listing is missing attributes" do
      listing = FactoryBot.create(:listing)
      rental_request = RentalRequest.create(return_date: "2022-10-28 00:00:00 UTC")
      expect(rental_request.valid?).to eq false
      expect(rental_request.errors[:return_date]).to be_empty
      expect(rental_request.errors[:pick_up_date]).to_not be_empty
    end
  end

end
