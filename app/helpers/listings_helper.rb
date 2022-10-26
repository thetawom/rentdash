module ListingsHelper
  def fee_unit_options
    options_for_select(Listing.fee_units.map{|key, value| [key.titleize, Listing.fee_units.key(value)]}, @listing.fee_unit)
  end
  def fee_time_options
    options_for_select(Listing.fee_times.map{|key, value| [key.titleize, Listing.fee_times.key(value)]}, @listing.fee_time)
  end
end