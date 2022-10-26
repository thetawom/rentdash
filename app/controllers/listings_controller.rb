class ListingsController < ApplicationController

  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.find_by(id: params[:id])
  end

  def new
    @listing = Listing.new
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

  def edit
    @listing = Listing.find_by(id: params[:id])
  end

  def update
    @listing = Listing.find_by(id: params[:id])
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

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit)
  end

end