require "rails_helper"

RSpec.describe RentalsHelper, type: :helper do

  describe "#payment_method_options" do
    it "generates options tags with all of the values" do
      options_enum = {"cash" => 0, "bitcoin" => 1, "favors" => 2}
      allow(Rental).to receive(:payment_methods).and_return(options_enum)
      options_str = payment_method_options
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

  describe "#status_options" do
    it "generates options tags with all of the values" do
      options_enum = {"never_happening" => 0, "happened" => 1}
      allow(Rental).to receive(:statuses).and_return(options_enum)
      options_str = status_options
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

end
