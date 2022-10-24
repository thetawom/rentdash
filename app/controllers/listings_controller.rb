class ListingsController < ApplicationController

  def show
  end

  def index
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.create(listing_params)
    if @listing.valid?
      redirect_to root_path
    else
      flash[:errors] = @listing.errors
      redirect_to new_listing_path
    end
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :rental_fee, :rental_fee_unit, :rental_fee_time, :deposit_amount)
  end

end