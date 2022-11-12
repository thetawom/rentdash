require 'rails_helper'

RSpec.describe ListingsHelper, type: :helper do

  describe "#fee_unit_options" do
    it "generates options tags with all of the values" do
      options_enum = {"karma" => 0, "dollars" => 1}
      allow(Listing).to receive(:fee_units).and_return(options_enum)
      options_str = fee_unit_options
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

  describe "#fee_time_options" do
    it "generates options tags with all of the values" do
      options_enum = {"second" => 0, "minute" => 1, "hour" => 2}
      allow(Listing).to receive(:fee_times).and_return(options_enum)
      options_str = fee_time_options
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

  describe "#item_category_options" do
    it "generates options tags with all of the values" do
      options_enum = {"other" => 0, "kangaroo_toys" => 1, "magic_boomerangs" => 2}
      allow(Listing).to receive(:item_categories).and_return(options_enum)
      options_str = item_category_options
      options_enum.keys.each do |key|
        expect(options_str).to include "value=\"#{key}\""
      end
    end
  end

end
