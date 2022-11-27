require "rails_helper"

RSpec.describe RentalRequestsHelper, type: :helper do

  describe "#payment_method_options" do
    it "generates options tags with all of the values" do
      listing = instance_double("Listing")
      options_enum = {"cash" => 0, "bitcoin" => 1, "favors" => 2}
      allow(listing).to receive(:accepted_payment_methods).and_return(options_enum)
      options_str = payment_method_options listing
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

end