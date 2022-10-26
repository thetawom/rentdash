class ListingsController < ApplicationController

  def show
    id = params[:id]
    @listing = Listing.find(id)
  end

  def index
    @listings = Listing.all
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.owner_id = current_user.id
    @listing.save
    if @listing.valid?
      redirect_to listings_path
    else
      flash[:errors] = @listing.errors
      redirect_to new_listing_path
    end
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit)
  end

end