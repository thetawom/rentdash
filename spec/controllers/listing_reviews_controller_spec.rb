require "rails_helper"

RSpec.describe ListingReviewsController, type: :controller do

  context "user is logged in" do
    let(:owner) { FactoryBot.create(:user) }
    let(:reviewer) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: owner) }
    let(:review) { FactoryBot.create(:listing_review, listing: listing, reviewer: reviewer) }

    describe "GET #new" do
      context "user is not the listing owner" do
        let!(:user) { reviewer }
        it "renders the edit template" do
          get :new, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to render_template "new"
        end
        it "creates a blank listing review" do
          listing_review = instance_double("ListingReview")
          allow(ListingReview).to receive(:new).and_return listing_review
          get :new, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(assigns(:listing)).to eq listing
          expect(assigns(:listing_review)).to eq listing_review
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          get :new, params: {listing_id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is the listing owner" do
        let!(:user) { owner }
        it "redirects to listing page" do
          get :new, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "POST #create" do
      context "user is not the listing owner" do
        let!(:user) { reviewer }
        it "creates new rental request if params are valid" do
          review = instance_double("ListingReview", id: 1, valid?: true)
          allow(review).to receive_messages(:listing= => nil, :reviewer= => nil, :save => nil)
          expect(ListingReview).to receive(:new).and_return(review)
          allow_any_instance_of(ListingReviewsController).to receive(:listing_review_params)
          post :create, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to new rental request page if params are invalid" do
          errors = instance_double("ActiveModel::Errors")
          review = instance_double("ListingReview", id: 1, valid?: false, errors: errors)
          allow(review).to receive_messages(:listing= => nil, :reviewer= => nil, :save => nil)
          expect(ListingReview).to receive(:new).and_return(review)
          allow_any_instance_of(ListingReviewsController).to receive(:listing_review_params)
          post :create, params:{listing_id: listing.id}, session: {user_id: user.id}
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to new_listing_review_path listing.id
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          post :create, params: {listing_id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is the listing owner" do
        let!(:user) { owner }
        it "redirects to listing page" do
          get :new, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "GET #edit" do
      context "user is the reviewer" do
        let!(:user) { reviewer }
        it "renders the edit template" do
          get :edit, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to render_template "edit"
        end
        it "assigns @listing_review by id" do
          get :edit, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(assigns(:listing_review)).to eq review
        end
        it "redirects to listing page if review does not exist" do
          expect(ListingReview).to receive(:find_by).and_return(nil)
          get :edit, params: {listing_id: listing.id, id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          get :edit, params: {listing_id: 0, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is not the reviewer" do
        let!(:user) { owner }
        it "redirects to listing page" do
          get :edit, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "PATCH #update" do
      context "user is the reviewer" do
        let!(:user) { reviewer }
        it "updates review if params are valid" do
          review = instance_double("ListingReview", id: 1, valid?: true, listing: listing, reviewer: reviewer)
          expect(review).to receive(:update)
          expect(ListingReview).to receive(:find_by).and_return(review)
          allow_any_instance_of(ListingReviewsController).to receive(:listing_review_params)
          patch :update, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to edit review page if params are invalid" do
          errors = instance_double("ActiveModel::Errors")
          review = instance_double("ListingReview", id: 1, valid?: false, errors: errors, listing: listing, reviewer: reviewer)
          expect(review).to receive(:update)
          expect(ListingReview).to receive(:find_by).and_return(review)
          allow_any_instance_of(ListingReviewsController).to receive(:listing_review_params)
          patch :update, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to edit_listing_review_path listing.id, review.id
        end
        it "redirects to listing page if review does not exist" do
          expect(ListingReview).to receive(:find_by).and_return(nil)
          patch :update, params: {listing_id: listing.id, id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          patch :update, params: {listing_id: 0, id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is not the reviewer" do
        let!(:user) { owner }
        it "redirects to listing page if user is not requester" do
          patch :update, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "DELETE #destroy" do
      context "user is the reviewer" do
        let!(:user) { reviewer }
        it "deletes rental request" do
          review = instance_double("ListingReview", id: 1, listing: listing, reviewer: reviewer)
          expect(ListingReview).to receive(:find_by).and_return(review)
          expect(review).to receive(:destroy)
          delete :destroy, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
        end
        it "redirects to listing page" do
          delete :destroy, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to listing page if review does not exist" do
          expect(ListingReview).to receive(:find_by).and_return(nil)
          delete :destroy, params: {listing_id: listing.id, id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          delete :destroy, params: {listing_id: 0, id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is not the reviewer" do
        let!(:user) { owner }
        it "does not delete request if user is not the requester" do
          review = instance_double("ListingReview", id: 1, listing: listing, reviewer: reviewer)
          expect(ListingReview).to receive(:find_by).and_return(review)
          expect(review).to_not receive(:destroy)
          delete :destroy, params: {listing_id: listing.id, id: review.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

  end

  context "user is not logged in" do
    describe "GET #new" do
      it "redirects to login page" do
        get :new, params: {listing_id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "POST #create" do
      it "redirects to login page" do
        post :create, params: {listing_id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "GET #edit" do
      it "redirects to login page" do
        get :edit, params: {listing_id: 1, id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "PATCH #update" do
      it "redirects to login page" do
        patch :update, params: {listing_id: 1, id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "DELETE #destroy" do
      it "redirects to login page" do
        delete :destroy, params: {listing_id: 1, id: 1}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#listing_review_params" do

    controller = ListingReviewsController.new

    it "raises ParameterMissing error if there is no listing_review parameter" do
      params_hash = { fake: { fake: "hello" } }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      expect{controller.send(:listing_review_params)}.to raise_error ActionController::ParameterMissing
    end

    it "returns only listing parameters with others filtered" do
      params_hash = {
        listing_review: { review: "This is excellent!",
                          rating: 18,
                          junk: "junk" },
        gunk: { hunk: "hunk" }
      }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      listing_review_params = controller.send :listing_review_params
      expect(listing_review_params).to include :review, :rating
      expect(listing_review_params).to_not include  :junk, :gunk, :hunk
    end

  end

end
