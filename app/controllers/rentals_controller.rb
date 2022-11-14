require 'date'
class RentalsController < ApplicationController

  def index
    current_time = DateTime.now
    @rentals = Rental.where(renter: current_user)
    @requests = RentalRequest.where(requester_id: current_user)
    @rentals.each do |rental|
      if current_time >= rental.request.pick_up_time and current_time <= rental.request.return_time
        rental.status = "ongoing"
        rental.save
      end
    end
  end

  def show
    @rental = Rental.find_by(id: params[:id])
  end

end