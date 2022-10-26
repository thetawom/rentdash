module ListingsHelper
  def fee_unit_options(select = nil)
    options_for_select(Listing.fee_units.map{|key, value| [key.titleize, key]}, select)
  end
  def fee_time_options(select = nil)
    options_for_select(Listing.fee_times.map{|key, value| [key.titleize, key]}, select)
  end
end