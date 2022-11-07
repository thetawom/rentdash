class ListingsController < ApplicationController

  def index
    @listings = Listing.all
    @all_categories = Listing.all_categories
    @all_payment_types = Listing.all_payment_types
    @all_rental_times = Listing.all_rental_times
    if params[:home] == nil
      redirect_to listings_path(:item_categories => session[:item_categories], :payment_types => session[:payment_types], :rental_times => session[:rental_times], :home => "1")
    else
      session[:item_categories] = params[:item_categories]
      session[:payment_types] = params[:payment_types]
      session[:rental_times] = params[:rental_times]
    end

    if session[:item_categories] == nil
      @item_categories_to_show = Listing.all_categories
    else
      @item_categories_to_show = session[:item_categories].keys
      @item_categories_hash = Hash[@item_categories_to_show.collect {|v| [v, 1]}]
    end

    if session[:payment_types] == nil
      @payment_types_to_show = Listing.all_payment_types
    else
      @payment_types_to_show = session[:payment_types].keys
      @payment_types_hash = Hash[@payment_types_to_show.collect {|v| [v, 1]}]
    end

    if session[:rental_times] == nil
      @rental_times_to_show = Listing.all_rental_times
    else
      @rental_times_to_show = session[:rental_times].keys
      @rental_times_hash = Hash[@rental_times_to_show.collect {|v| [v, 1]}]
    end

    @listings = Listing.with_filters(@item_categories_hash, @payment_types_to_show_hash, @rental_times_hash)

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
    params.require(:listing).permit(:name, :description, :pick_up_location, :fee, :fee_unit, :fee_time, :deposit, :item_category)
  end

end