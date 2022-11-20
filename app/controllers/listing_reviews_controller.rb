class ListingReviewsController < ApplicationController

  before_action :require_reviewer, only: [:edit, :update, :destroy]
  def new
    @listing = Listing.find params[:listing_id]
    @listing_review = ListingReview.new
  end

  def create
    @listing_review = ListingReview.new listing_review_params
    @listing_review.listing_id = params[:listing_id]
    @listing_review.reviewer = current_user
    @listing_review.save

    if @listing_review.valid?
      redirect_to listing_path @listing_review.listing.id
    else
      flash[:error] = @listing_review.errors
      redirect_to new_listing_review_path params[:listing_id]
    end
  end

  def edit; end

  def update
    @listing_review.update listing_review_params
    if @listing_review.valid?
      flash[:success] = "Review for #{@listing.name} was updated!"
      redirect_to listing_path @listing.id
    else
      flash[:error] = @listing_review.errors
      redirect_to edit_listing_review_path [@listing.id, @listing_review.id]
    end
  end

  def destroy
    @listing_review.destroy
    flash[:notice] = "Review for #{@listing.name} was deleted."
    redirect_to listing_path @listing.id
  end

  private

  def listing_review_params
    params.require(:listing_review).permit(:review, :rating)
  end

  def require_reviewer
    @listing = Listing.find_by id: params[:listing_id]
    if @listing.nil?
      redirect_to listings_path
    else
      @listing_review = ListingReview.find_by id: params[:id], listing: @listing
      if @listing_review.nil?
        redirect_to listing_path @listing.id
      elsif @listing_review.reviewer != current_user
        redirect_to listing_path @listing.id
      end
    end
  end

end