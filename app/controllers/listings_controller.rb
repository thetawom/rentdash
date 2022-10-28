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
    @listing = Listing.find_by id: params[:id], owner: current_user
    redirect_to listings_path if @listing.nil?
  end

  def update
    @listing = Listing.find_by id: params[:id], owner: current_user
    if @listing.nil?
      redirect_to listings_path
<<<<<<< HEAD
      return
    end
    @listing.update(listing_params)
    if @listing.valid?
      flash[:notice] = "#{@listing.name} was updated!"
      redirect_to listing_path @listing.id
=======
>>>>>>> c63779471c58a8d7f3c35dbcb870fd057e586552
    else
      @listing.update(listing_params)
      if @listing.valid?
        flash[:notice] = "#{@listing.name} was updated!"
        redirect_to listing_path @listing.id
      else
        flash[:errors] = @listing.errors
        redirect_to new_listing_path
      end
    end
  end

  def destroy
    @listing = Listing.find_by id: params[:id], owner: current_user
    if @listing.nil?
      redirect_to listings_path
    else
      @listing.destroy
      flash[:notice] = "#{@listing.name} was deleted."
      redirect_to listings_path
    end
  end

  def mine
    @listings = Listing.where(owner: current_user)
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit)
  end

end