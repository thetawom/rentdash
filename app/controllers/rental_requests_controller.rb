class RentalRequestsController < ApplicationController

  before_action :require_not_listing_owner, only: [:new, :create]
  before_action :require_requester, only: [:edit, :update, :destroy]
  before_action :require_listing_owner, only: [:approve, :decline]

  def index
    @listing = Listing.find_by(id: params[:listing_id])
    @lister_phone = User.find_by(id: @listing.owner_id).phone
    if @listing.owner == current_user
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id])
      @is_owner = true
    else
      @rental_requests = RentalRequest.where(listing_id: params[:listing_id], requester: current_user)
      @is_owner = false
    end
  end

  def new
    @rental_request = RentalRequest.new
    @rental_request.update rental_request_params if params.has_key? :rental_request
    @show_estimated_cost = true if params.has_key? :cost
    @estimated_cost = params[:cost] if params.has_key? :cost
  end

  def create
    @pick_up_time = params[:rental_request][:pick_up_time].to_datetime
    @return_time = params[:rental_request][:return_time].to_datetime
    @listing = Listing.find_by(id: params[:listing_id])
    @estimated_cost = calculate_estimated_cost(@pick_up_time, @return_time, @listing)
    if params[:calculate_estimated_cost]
      redirect_to new_listing_rental_request_path @listing.id, rental_request: rental_request_params, cost: @estimated_cost
    else
      return if check_karma @estimated_cost, "create"
      @rental_request = RentalRequest.new rental_request_params
      @rental_request.listing = @listing
      @rental_request.requester = current_user
      @rental_request.save
      if @rental_request.valid?
        redirect_to listing_rental_requests_path @listing.id
      else
        redirect_to new_listing_rental_request_path @listing.id, rental_request: rental_request_params
      end
    end
  end

  def edit
    if @rental_request.status != "pending"
      flash[:error] = "You can no longer make any changes to this request."
      redirect_to listing_rental_requests_path @listing.id
    end
    @rental_request.update rental_request_params if params.has_key? :rental_request
    @show_estimated_cost = true if params.has_key? :cost
    @estimated_cost = params[:cost] if params.has_key? :cost
  end

  def update
    @pick_up_time = params[:rental_request][:pick_up_time].to_datetime
    @return_time = params[:rental_request][:return_time].to_datetime
    @rental_request = RentalRequest.find_by(id: params[:id])
    @listing = Listing.find_by(id: @rental_request.listing_id.to_s)
    @estimated_cost = calculate_estimated_cost(@pick_up_time, @return_time, @listing)
    if params[:calculate_estimated_cost]
      redirect_to edit_rental_request_path @rental_request.id, rental_request: rental_request_params, cost: @estimated_cost
    else
      if @rental_request.status != "pending"
        redirect_to listing_rental_requests_path @listing.id
      else
        return if check_karma @estimated_cost, "update"
        @rental_request.update rental_request_params
        if @rental_request.valid?
          flash[:success] = "Request for #{@listing.name} was updated!"
          redirect_to listing_rental_requests_path @listing.id
        else
          redirect_to edit_rental_request_path @rental_request.id, rental_request: rental_request_params
        end
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
    redirect_to listing_rental_requests_path @listing.id
  end

  def decline
    @rental_request.decline
    redirect_to listing_rental_requests_path @listing.id
  end

  def check_karma(estimated_cost, method)
    if current_user.karma - estimated_cost < 0
      flash[:error] = "You do not have enough karma to make this request."
      if method == "create"
        redirect_to new_listing_rental_request_path @listing.id, rental_request: rental_request_params
      else
        redirect_to edit_rental_request_path @rental_request.id, rental_request: rental_request_params
      end
    end
    true
  end

  private
  def rental_request_params
    params.require(:rental_request).permit(:pick_up_time, :return_time, :payment_method)
  end

  def require_not_listing_owner
    @listing = Listing.find_by id: params[:listing_id]
    if @listing.nil?
      redirect_to listings_path
    elsif @listing.owner == current_user
      redirect_to listing_path @listing
    end
  end

  def require_requester
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.nil?
      redirect_to listings_path
    else
      @listing = @rental_request.listing
      if @rental_request.requester != current_user
        redirect_to listing_path @listing.id
      end
    end
  end

  def require_listing_owner
    @rental_request = RentalRequest.find_by id: params[:id]
    if @rental_request.nil?
      redirect_to listings_path
    else
      @listing = @rental_request.listing
      if @listing.owner != current_user
        redirect_to listing_path @listing.id
      end
    end
  end

  def calculate_estimated_cost(pick_up_time, return_time, listing)
    @listing_fee_time = listing.fee_time
    @listing_fee = listing.fee
    @listing_fee_unit = listing.fee_unit
    if @listing_fee_time == 'hour'
      @estimated_cost = ((return_time - pick_up_time)*24).ceil() * @listing_fee
    elsif @listing_fee_time == 'day'
      @estimated_cost = (return_time - pick_up_time).ceil() * @listing_fee
    elsif @listing_fee_time == 'week'
      @estimated_cost = ((return_time - pick_up_time)/7).ceil() * @listing_fee
    end
    return @estimated_cost
  end
end