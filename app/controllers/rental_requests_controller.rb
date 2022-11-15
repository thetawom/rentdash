class RentalRequestsController < ApplicationController

  before_action :require_requester, only: [:edit, :update, :destroy]
  before_action :require_listing_owner, only: [:approve, :decline]

  def index
    @listing = Listing.find_by(id: params[:listing_id])
    if @listing.owner == current_user
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id])
    else
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id], requester: current_user)
    end
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
      redirect_to listing_rental_requests_path @rental_request.listing.id
    else
      flash[:error] = @rental_request.errors
      redirect_to new_listing_rental_request_path params[:listing_id]
    end
  end

  def edit
    if @rental_request.status != "pending"
      flash[:error] = "You can no longer make any changes to this request."
      redirect_to listing_rental_requests_path @rental_request.listing.id
    end
  end

  def update
    if @rental_request.status != "pending"
      redirect_to listing_rental_requests_path @rental_request.listing.id
    else
      @rental_request.update(rental_request_params)
      if @rental_request.valid?
        flash[:success] = "Request for #{@rental_request.listing.name} was updated!"
        redirect_to listing_rental_requests_path @rental_request.listing.id
      else
        flash[:error] = @rental_request.errors
        redirect_to edit_rental_request_path @rental_request.id
      end
    end
  end

  def destroy
    listing = @rental_request.listing
    @rental_request.destroy
    flash[:notice] = "Request for #{@rental_request.listing.name} was deleted."
    redirect_to listing_rental_requests_path listing.id
  end

  def approve
    @rental_request.approve
    redirect_to listing_rental_requests_path @rental_request.listing.id
  end

  def decline
    @rental_request.decline
    redirect_to listing_rental_requests_path @rental_request.listing.id
  end

  private
  def rental_request_params
    params.require(:rental_request).permit(:pick_up_time, :return_time)
  end

  def require_requester
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.nil?
      redirect_to listings_path
    elsif @rental_request.requester != current_user
      redirect_to listing_path @rental_request.listing
    end
  end

  def require_listing_owner
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.nil?
      redirect_to listings_path
    elsif @rental_request.listing.owner != current_user
      redirect_to listing_path @rental_request.listing
    end
  end

end