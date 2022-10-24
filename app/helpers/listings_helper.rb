module ListingsHelper
  def rental_fee_unit_options
    options_for_select(Listing.rental_fee_units.map{|key, value| [key.titleize, Listing.rental_fee_units.key(value)]}, @listing.rental_fee_unit)
  end
  def rental_fee_time_options
    options_for_select(Listing.rental_fee_times.map{|key, value| [key.titleize, Listing.rental_fee_times.key(value)]}, @listing.rental_fee_time)
  end
end