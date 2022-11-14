module ListingsHelper
  def fee_unit_options(listing = nil)
    options_for_select(Listing.fee_units.map{|key, value| [key.titleize, key]}, listing&.fee_unit)
  end
  def fee_time_options(listing = nil)
    options_for_select(Listing.fee_times.map{|key, value| [key.titleize, key]}, listing&.fee_time)
  end
  def item_category_options(listing = nil)
    options_for_select(Listing.item_categories.map{|key, value| [key.titleize, key]}, listing&.item_category)
  end
end