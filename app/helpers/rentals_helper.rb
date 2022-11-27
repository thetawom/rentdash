module RentalsHelper

  def status_options(rental = nil)
    options_for_select(Rental.statuses.map{|key, value| [key.titleize, key]}, rental&.status)
  end

end