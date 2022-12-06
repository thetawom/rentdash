require 'date'
class RentalsController < ApplicationController

  before_action :require_renter_or_listing_owner, only: [:show, :cancel]
  before_action :require_listing_owner, only: [:edit, :update]

  def index
    @rentals = Rental.where(renter: current_user)
    @requests = RentalRequest.where(requester: current_user)
    @pending_requests = @requests.where(status: "pending")
    @ongoing_rentals = @rentals.where(status: "ongoing")
    @upcoming_rentals = @rentals.where(status: "upcoming")
    @past_rentals = @rentals.where(status: "completed")
  end

  def show
    @rental_request = @rental.request
    @listing = @rental.listing
  end

  def edit
    @rental_request = @rental.request
    @listing = @rental.listing
    @rental_request.update rental_request_params if params.has_key? :rental_request
    @listing.update listing_params if params.has_key? :listing
  end

  def update
    @rental.update rental_params
    @rental.request.update rental_request_params
    if @rental.valid? and @rental.request.valid?
      flash[:success] = "Request for #{@rental.listing.name} was updated!"
      redirect_to rental_path @rental.id
    else
      redirect_to edit_rental_path @rental.id, rental: rental_params, rental_request: rental_request_params
    end
  end

  def cancel
    @rental.cancel
    flash[:notice] = "Rental for #{@rental.listing.name} was cancelled."
    redirect_to rental_path @rental.id
  end

  private

  def rental_params
    params.require(:rental).permit(:status)
  end

  def rental_request_params
    params.require(:rental_request).permit(:pick_up_time, :return_time, :payment_method)
  end

  def require_renter_or_listing_owner
    @rental = Rental.find_by id: params[:id]
    if @rental.nil?
      redirect_to my_listings_path
    elsif @rental.renter != current_user and @rental.listing.owner != current_user
      redirect_to rentals_path
    end
  end

  def require_listing_owner
    @rental = Rental.find_by id: params[:id]
    if @rental.nil?
      redirect_to my_listings_path
    elsif @rental.listing.owner != current_user
      redirect_to listing_path @rental.listing
    end
  end

end