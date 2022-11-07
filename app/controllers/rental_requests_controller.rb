class RentalRequestsController < ApplicationController
  def index
    @listing = Listing.find_by(id: params[:listing_id])
    @rental_requests = RentalRequest.where(listing_id: params[:listing_id])
  end

  def new
    @listing = Listing.find params[:listing_id]
    @rental_request = RentalRequest.new
  end

  def create
    @rental_request = RentalRequest.new rental_request_params
    @rental_request.listing_id = params[:listing_id]
    @rental_request.requester = current_user
    @rental_request.save
    
    if @rental_request.valid?
      redirect_to listing_path params[:listing_id]
    else
      flash[:errors] = @rental_request.errors
      redirect_to new_listing_rental_request_path params[:listing_id]
    end
    
  end

  def mine
    @rental_requests = RentalRequest.where(requester: current_user)
  end

  private
  def rental_request_params
    params.require(:rental_request).permit(:pick_up_date, :return_date)
  end

end