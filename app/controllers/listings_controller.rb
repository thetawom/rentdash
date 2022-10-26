class ListingsController < ApplicationController

  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.find_by id: params[:id]
    @is_mine = @listing.owner == current_user
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new listing_params
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
    @listing = get_protected_listing(params[:id])
  end

  def update
    @listing = get_protected_listing(params[:id])
    @listing.update(listing_params)
    if @listing.valid?
      flash[:notice] = "#{@listing.name} was updated!"
      redirect_to listing_path @listing
    else
      flash[:errors] = @listing.errors
      redirect_to new_listing_path
    end
  end

  def destroy
    @listing = get_protected_listing(params[:id])
    @listing.destroy
    flash[:notice] = "#{@listing.name} was deleted."
    redirect_to listings_path
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit)
  end

  def get_protected_listing(id)
    listing = Listing.find_by id: id
    if listing.nil?
      flash[:notice] = "Listing does not exist."
      redirect_to listings_path
    elsif listing.owner != current_user
      flash[:notice] = "You are not the owner of this listing."
      redirect_to listings_path
    end
    listing
  end

end