class ListingsController < ApplicationController

  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.find_by(id: params[:id])
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
      redirect_to listing_path @listing.id
    else
      flash[:errors] = @listing.errors
      redirect_to new_listing_path
    end
  end

  def edit
    @listing = get_protected_listing(params[:id])
    redirect_to listings_path if @listing.nil?
  end

  def update
    @listing = get_protected_listing(params[:id])
    if @listing.nil?
      redirect_to listings_path
      return
    end
    @listing.update(listing_params)
    if @listing.valid?
      flash[:notice] = "#{@listing.name} was updated!"
      redirect_to listing_path @listing.id
    else
      flash[:errors] = @listing.errors
      redirect_to new_listing_path
    end
  end

  def mine
    @listings = Listing.where(owner: current_user)
  end

  def destroy
    @listing = get_protected_listing(params[:id])
    if @listing.nil?
      redirect_to listings_path
      return
    end
    @listing.destroy
    flash[:notice] = "#{@listing.name} was deleted."
    redirect_to listings_path
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit)
  end

  def get_protected_listing(id)
    listing = Listing.find_by(id: id)
    if listing.nil?
      flash[:notice] = "Listing does not exist."
      return nil
    elsif listing.owner != current_user
      flash[:notice] = "You are not the owner of this listing."
      return nil
    end
    listing
  end

end