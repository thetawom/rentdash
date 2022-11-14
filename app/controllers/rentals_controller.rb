require 'date'
class RentalsController < ApplicationController

  def index
    @rentals = Rental.where(renter: current_user)
    @requests = RentalRequest.where(requester: current_user)
    @pending = @requests.where(status: "pending")
    @ongoing = @rentals.where(status: "ongoing")
    @upcoming = @rentals.where(status: "upcoming")
  end

  def show
    @rental = Rental.find_by id: params[:id]
    redirect_to rentals_path unless @rental.listing.owner == current_user or @rental.renter == current_user
  end

  def edit
    @rental = Rental.find_by id: params[:id]
    if @rental.nil? or @rental.listing.owner != current_user
      redirect_to my_listings_path
    else
      @rental_request = @rental.request
    end
  end

  def update
    @rental = Rental.find_by id: params[:id]
    if @rental.nil? or @rental.listing.owner != current_user
      redirect_to my_listings_path
    else
      @rental.update rental_params
      @rental.request.update rental_request_params
      if @rental.valid? and @rental.request.valid?
        flash[:success] = "Request for #{@rental.listing.name} was updated!"
      else
        flash[:error] = @rental.errors.merge(@rental_request.errors)
      end
      redirect_to rental_path @rental.id
    end
  end

  def cancel
    @rental = Rental.find_by id: params[:id]
    unless @rental.nil? or @rental.listing.owner != current_user
      @rental.update status: "cancelled"
      flash[:notice] = "Rental for #{@rental.listing.name} was cancelled."
    end
    redirect_to rental_path @rental.id
  end

  private

  def rental_params
    params.require(:rental).permit(:status, :payment_method)
  end

  def rental_request_params
    params.require(:rental_request).permit(:pick_up_time, :return_time)
  end

end