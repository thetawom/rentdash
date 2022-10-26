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

  def edit
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    @listing.update(listing_params)
    flash[:notice] = "#{@listing.name} was updated!"
    redirect_to listing_path(@listing)
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    flash[:notice] = "#{@listing.name} was deleted."
    redirect_to listings_path
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.owner = current_user
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