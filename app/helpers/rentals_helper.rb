module RentalsHelper

  def payment_method_options(rental = nil)
    options_for_select(Rental.payment_methods.map{|key, value| [key.titleize, key]}, rental&.payment_method)
  end

  def status_options(rental = nil)
    options_for_select(Rental.statuses.map{|key, value| [key.titleize, key]}, rental&.status)
  end

end