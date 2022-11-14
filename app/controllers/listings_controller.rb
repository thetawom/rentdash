require 'date'
class ListingsController < ApplicationController

  def index
    @filtered_params = filter_params

    categories = @filtered_params[:categories]&.keys
    fee_units = @filtered_params[:fee_units]&.keys
    fee_times = @filtered_params[:fee_times]&.keys
    sort = @filtered_params[:sort]
    search = @filtered_params[:search]

    unless @filtered_params[:home]
      categories = session[:categories] if categories.nil?
      fee_units = session[:fee_units] if fee_units.nil?
      fee_times = session[:fee_times] if fee_times.nil?
      sort = session[:sort] if sort.nil?
      search = session[:search] if search.nil?
      categories_hash = categories && Hash[categories.collect {|v| [v, 1]}]
      fee_units_hash = fee_units && Hash[fee_units.collect {|v| [v, 1]}]
      fee_times_hash = fee_times && Hash[fee_times.collect {|v| [v, 1]}]
      redirect_to listings_path categories: categories_hash, fee_units: fee_units_hash, fee_times: fee_times_hash, sort: sort, search: search, home: "1"
    end

    @listings = Listing.with_filters(categories, fee_units, fee_times, search)

    case sort
      when "Sort Price High to Low" then @listings = @listings.order("fee").reverse
      when "Sort Price Low to High" then @listings = @listings.order("fee")
      when "Sort by Newest" then @listings = @listings.order("created_at").reverse
      when "Sort by Oldest" then @listings = @listings.order("created_at")
      else sort = nil
    end

    session[:categories] = categories
    session[:fee_units] = fee_units
    session[:fee_times] = fee_times
    session[:sort] = sort
    session[:search] = search

    @all_categories = Listing.all_item_categories
    @all_fee_units = Listing.all_fee_units
    @all_fee_times = Listing.all_fee_times
    @categories_to_show = categories.nil? ? @all_categories : categories
    @fee_units_to_show = fee_units.nil? ? @all_fee_units : fee_units
    @fee_times_to_show = fee_times.nil? ? @all_fee_times : fee_times

    @heading = (search.nil? or search == "") ? "All Listings" : "Search results for \"#{search}\""

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
      flash[:success] = "Listing for #{@listing.name} was successfully created!"
      redirect_to listing_path @listing.id
    else
      flash[:error] = @listing.errors
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
        flash[:error] = @listing.errors
        redirect_to new_listing_path
      end
    end
  end

  def destroy
    @listing = Listing.find_by id: params[:id], owner: current_user
    unless @listing.nil?
      @listing.destroy
      flash[:notice] = "#{@listing.name} was deleted."
    end
    redirect_to my_listings_path
  end

  def mine
    @listings = Listing.where(owner: current_user)

    @requests = RentalRequest.where(listing_id: @listings.pluck(:id))
    @pending = @requests.where(status: "pending")

    @rentals = Rental.where(listing_id: @listings.pluck(:id))
    @upcoming = @rentals.where(status: "upcoming")
    @ongoing = @rentals.where(status: "ongoing")
  end

  private

  def filter_params
    params.permit(:home, :sort, :search,
                  categories: Listing.all_item_categories,
                  fee_units: Listing.all_fee_units,
                  fee_times: Listing.all_fee_times)
  end
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit, :item_category)
  end

end