require 'date'
class RentalsController < ApplicationController

  def index
    current_time = DateTime.now
    @rentals = Rental.where(renter: current_user)
    @requests = RentalRequest.where(requester_id: current_user)
    @pending = @requests.where(status: "pending")
    @rentals.each do |rental|
      if current_time >= rental.request.pick_up_time and current_time <= rental.request.return_time
        rental.status = "ongoing"
        rental.save
      end
    end
    @ongoing = @rentals.where(status: "ongoing")
    @upcoming = @rentals.where(status: "upcoming")
  end

  def show
    @rental = Rental.find_by(id: params[:id])
  end

end