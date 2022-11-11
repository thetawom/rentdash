class RentalRequestsController < ApplicationController
  def index
    @listing = Listing.find_by(id: params[:listing_id])
    redirect_to listing_path @listing.id if @listing.owner != current_user
    @rental_requests = RentalRequest.where(listing_id: params[:listing_id])
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
      redirect_to listing_path params[:listing_id]
    else
      flash[:errors] = @rental_request.errors
      redirect_to new_listing_rental_request_path params[:listing_id]
    end
  end

  def destroy
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.requester == current_user
      unless @rental_request.nil?
        @rental_request.destroy
        flash[:notice] = "Request for #{@rental_request.listing.name} was deleted."
      end
      redirect_to my_requests_path
    elsif @rental_request.listing.owner == current_user
      unless @rental_request.nil?
        @rental_request.destroy
        flash[:notice] = "Request for #{@rental_request.listing.name} was declined."
      end
      redirect_to listing_rental_requests_path(@rental_request.listing.id)
    else
      redirect_to my_requests_path
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