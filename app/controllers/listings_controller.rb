class ListingsController < ApplicationController

  def index
    @listings = Listing.all
    @all_categories = Listing.all_categories
    @all_payment_types = Listing.all_payment_types
    @all_rental_times = Listing.all_rental_times
    if params[:home] == nil
      redirect_to listings_path(:category => session[:category], :payment => session[:payment], :times => session[:time], :sort => session[:sort], :search => session[:search], :home => "1")
    else
      session[:category] = params[:category]
      session[:payment] = params[:payment]
      session[:time] = params[:time]
      session[:sort] = params[:sort]
      session[:search] = params[:search]
    end

    if session[:category] == nil
      @item_categories_to_show = Listing.all_categories
    else
      @item_categories_to_show = session[:category].keys
      @item_categories_hash = Hash[@item_categories_to_show.collect {|v| [v, 1]}]
    end

    if session[:payment] == nil
      @payment_types_to_show = Listing.all_payment_types
    else
      @payment_types_to_show = session[:payment].keys
      @payment_types_hash = Hash[@payment_types_to_show.collect {|v| [v, 1]}]
    end

    if session[:time] == nil
      @rental_times_to_show = Listing.all_rental_times
    else
      @rental_times_to_show = session[:time].keys
      @rental_times_hash = Hash[@rental_times_to_show.collect {|v| [v, 1]}]
    end

    # if session[:sort] != nil
    #   @listings = Listing.with_filters(@item_categories_hash, @payment_types_to_show_hash, @rental_times_hash).order(session[:sort])
    # else
    #   @listings = Listing.with_filters(@item_categories_hash, @payment_types_to_show_hash, @rental_times_hash)
    # end

    
    @listings = Listing.with_filters(@item_categories_hash, @payment_types_hash, @rental_times_hash)

    if session[:sort] && session[:sort] == "Sort Price High to Low"
      @listings = @listings.order("fee").reverse
    elsif session[:sort] && session[:sort] == "Sort Price Low to High"
      @listings = @listings.order("fee")
    elsif session[:sort] && session[:sort] == "Sort by Newest"
      @listings = @listings.order("created_at").reverse
    elsif session[:sort] && session[:sort] == "Sort by Oldest"
      @listings = @listings.order("created_at")
    end

    #@listings = Listing.where("name LIKE ?", "%" + session[:search] + "%")


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
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit, :item_category, :sort, :search)
  end

end