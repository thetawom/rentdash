require "rails_helper"

RSpec.describe ListingReviewsController, type: :controller do

  context "user is logged in" do
    pending "GET #new"
    pending "POST #create"
    pending "GET #edit"
    pending "PATCH #update"
    pending "DELETE #destroy"
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
