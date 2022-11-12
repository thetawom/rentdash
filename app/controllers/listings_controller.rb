class ListingsController < ApplicationController

  def index
    @listings = Listing.all
    @all_categories = Listing.item_category_options
    @all_payment_types = Listing.fee_unit_options
    @all_rental_times = Listing.fee_time_options
    @payment_types_dictionary = {'karma' => 0, 'dollars' => 1}
    @rental_times_dictionary = {'hour' => 0, 'day' => 1, 'week' => 2}
    puts(params)
    if params[:home] == nil
      redirect_to listings_path(:category => session[:category], :payment => session[:payment], :times => session[:time], :sort => session[:sort], :search => session[:search], :home => "1")
    elsif params[:home] == '2'
      session[:search] = params[:search]
    else
      session[:category] = params[:category]
      session[:payment] = params[:payment]
      session[:time] = params[:time]
      session[:sort] = params[:sort]
    end

    if session[:category] == nil
      @item_categories_to_show = Listing.item_category_options
    else
      @item_categories_to_show = session[:category].keys
      @item_categories_hash = Hash[@item_categories_to_show.collect {|v| [v, 1]}]
    end

    if session[:payment] == nil
      @payment_types_to_show = Listing.fee_unit_options
    else
      @payment_types_to_show = session[:payment].keys
      @payment_types_original = Hash[@payment_types_to_show.collect {|v| [v, 1]}]
      @payment_types_hash = Hash[@payment_types_to_show.collect {|v| [@payment_types_dictionary[v], 1]}]
    end

    if session[:time] == nil
      @rental_times_to_show = Listing.fee_time_options
    else
      @rental_times_to_show = session[:time].keys
      @rental_times_original = Hash[@rental_times_to_show.collect {|v| [v, 1]}]
      @rental_times_hash = Hash[@rental_times_to_show.collect {|v| [@rental_times_dictionary[v], 1]}]
    end

    
    @listings = Listing.with_filters(@item_categories_hash, @payment_types_hash, @rental_times_hash, session[:search])

    if session[:sort] && session[:sort] == "Sort Price High to Low"
      @listings = @listings.order("fee").reverse
    elsif session[:sort] && session[:sort] == "Sort Price Low to High"
      @listings = @listings.order("fee")
    elsif session[:sort] && session[:sort] == "Sort by Newest"
      @listings = @listings.order("created_at").reverse
    elsif session[:sort] && session[:sort] == "Sort by Oldest"
      @listings = @listings.order("created_at")
    end

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
    unless @listing.nil?
      @listing.destroy
      flash[:notice] = "#{@listing.name} was deleted."
    end
    redirect_to my_listings_path
  end

  def mine
    @listings = Listing.where(owner: current_user)
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit, :item_category)
  end

end