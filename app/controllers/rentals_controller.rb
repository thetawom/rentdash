class RentalsController < ApplicationController

  def index
    @rentals = Rental.where(renter: current_user)
  end

end