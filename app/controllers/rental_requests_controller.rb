class RentalRequestsController < ApplicationController
  def index
    @listing = Listing.find_by(id: params[:listing_id])
    if @listing.owner == current_user
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id])
    else
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id], requester: current_user)
    end
  end

  def show
    @rental_request = RentalRequest.find_by id: params[:id]
    @listing = @rental_request.listing
    @is_my_request = @rental_request.requester == current_user
    @is_my_listing = @listing.owner == current_user
    if not @is_my_request and not @is_my_listing
      redirect_to my_requests_path
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
    @rental_request = RentalRequest.find_by id: params[:id], requester: current_user
    if @rental_request.nil?
      redirect_to my_requests_path
    elsif @rental_request.status != "pending"
      flash[:error] = "You can no longer make any changes."
      redirect_to listing_rental_requests_path @rental_request.listing.id
    end
  end

  def update
    @rental_request = RentalRequest.find_by id: params[:id], requester: current_user
    if @rental_request.nil?
      redirect_to my_requests_path
    elsif @rental_request.status != "pending"
      redirect_to listing_rental_requests_path @rental_request.listing.id
    else
      @rental_request.update(rental_request_params)
      if @rental_request.valid?
        flash[:success] = "Request for #{@rental_request.listing.name} was updated!"
        redirect_to listing_rental_requests_path @rental_request.listing.id
      else
        flash[:error] = @rental_request.errors
        redirect_to new_listing_rental_request_path @rental_request.listing.id
      end
    end
  end

  def destroy
    @rental_request = RentalRequest.find_by id: params[:id], requester: current_user
    if @rental_request.nil?
      redirect_to my_requests_path
    else
      listing = @rental_request.listing
      @rental_request.destroy
      flash[:notice] = "Request for #{@rental_request.listing.name} was deleted."
      redirect_to listing_rental_requests_path listing.id
    end
  end

  def mine
    @rental_requests = RentalRequest.where(requester: current_user)
  end

  def approve
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.listing.owner == current_user
      @rental_request.approve
      redirect_to listing_rental_requests_path @rental_request.listing.id
    else
      redirect_to my_requests_path
    end
  end

  def decline
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.listing.owner == current_user
      @rental_request.decline
      redirect_to listing_rental_requests_path @rental_request.listing.id
    else
      redirect_to my_requests_path
    end
  end

  private
  def rental_request_params
    params.require(:rental_request).permit(:pick_up_time, :return_time)
  end

end