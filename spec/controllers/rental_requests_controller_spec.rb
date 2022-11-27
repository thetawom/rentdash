require "rails_helper"

RSpec.describe RentalRequestsController, type: :controller do

  context "user is logged in" do

    let(:owner) { FactoryBot.create(:user) }
    let(:requester) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: owner) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: requester)}

    describe "GET #index" do

      let(:other_request) { FactoryBot.create(:rental_request, listing: listing) }
      let(:irrelevant_request) { FactoryBot.create(:rental_request) }

      context "user is the listing owner" do
        let!(:user) { owner }
        it "renders the index template" do
          get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to render_template "index"
        end
        it "assigns @rental_requests" do
          get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(assigns(:listing)).to eq listing
          expect(assigns(:rental_requests)).to include request
          expect(assigns(:rental_requests)).to include other_request
          expect(assigns(:rental_requests)).to_not include irrelevant_request
        end
      end
      context "user is not the listing owner" do
        let!(:user) { requester }
        it "renders the index template" do
          get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to render_template "index"
        end
        it "assigns @rental_requests" do
          get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(assigns(:rental_requests)).to include request
          expect(assigns(:rental_requests)).to_not include other_request
          expect(assigns(:rental_requests)).to_not include irrelevant_request
        end
      end
    end

    describe "GET #new" do
      context "user is not the listing owner" do
        let!(:user) { requester }
        it "renders the new template" do
          get :new, params:{listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to render_template "new"
        end
        it "creates a blank rental request" do
          rental_request = instance_double("RentalRequest")
          allow(RentalRequest).to receive(:new).and_return rental_request
          get :new, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(assigns(:listing)).to eq listing
          expect(assigns(:rental_request)).to eq rental_request
        end
      end
      context "user is the listing owner" do
        let!(:user) { owner }
        it "redirects to listing page" do
          get :new, params:{listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
        it "redirects to listings page if listing does not exist" do
          expect(Listing).to receive(:find_by).and_return(nil)
          get :new, params: {listing_id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
    end

    describe "POST #create" do
      context "user is not the listing owner" do
        let!(:user) { requester }
        it "creates new rental request if params are valid" do
          rental_request = instance_double("RentalRequest", id: 1, listing: listing)
          allow(rental_request).to receive(:valid?).and_return(true)
          allow(rental_request).to receive(:listing=)
          allow(rental_request).to receive(:requester=)
          expect(rental_request).to receive(:save)
          expect(RentalRequest).to receive(:new).and_return(rental_request)
          allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
          post :create, params: {listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
        it "redirects to new rental request page if params are invalid" do
          rental_request = instance_double("RentalRequest", listing_id: 1)
          errors = instance_double("ActiveModel::Errors")
          allow(rental_request).to receive(:listing=)
          allow(rental_request).to receive(:requester=)
          allow(rental_request).to receive(:valid?).and_return(false)
          allow(rental_request).to receive(:errors).and_return(errors)
          expect(rental_request).to receive(:save)
          expect(RentalRequest).to receive(:new).and_return(rental_request)
          allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
          post :create, params:{listing_id: listing.id}, session: {user_id: user.id}
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to new_listing_rental_request_path
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
          post :create, params:{listing_id: listing.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "GET #edit" do
      context "user is the requester" do
        let!(:user) { requester }
        it "renders the edit template" do
          get :edit, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to render_template "edit"
        end
        it "assigns @rental_request by id" do
          get :edit, params: {id: request.id}, session: {user_id: user.id}
          expect(assigns(:rental_request)).to eq request
        end
        it "redirects to listings page if request does not exist" do
          expect(RentalRequest).to receive(:find_by).and_return(nil)
          get :edit, params: {id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
        it "redirects to listing requests page if request is no longer pending" do
          request.approve
          get :edit, params: {id: request.id}, session: {user_id: user.id}
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
      end
      context "user is not the requester" do
        let!(:user) { owner }
        it "redirects to listing page" do
          get :edit, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "PATCH #update" do
      context "user is the requester" do
        let!(:user) { requester }
        it "updates request if params are valid" do
          request = instance_double("RentalRequest", id: 1, valid?: true, status: "pending", listing: listing, requester: requester)
          expect(request).to receive(:update)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
          patch :update, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
        it "redirects to edit rental request page if params are invalid" do
          errors = instance_double("ActiveModel::Errors")
          request = instance_double("RentalRequest", id: 1, valid?: false, status: "pending", listing: listing, requester: requester, errors: errors)
          expect(request).to receive(:update)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
          patch :update, params: {id: request.id}, session: {user_id: user.id}
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to edit_rental_request_path request.id
        end
        it "redirects to listings page if request does not exist" do
          expect(RentalRequest).to receive(:find_by).and_return(nil)
          patch :update, params: {id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
        it "redirects to listing requests page if request is no longer pending" do
          request.approve
          patch :update, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
      end
      context "user is not the requester" do
        let!(:user) { owner }
        it "redirects to listing page if user is not requester" do
          patch :update, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "DELETE #destroy" do
      context "user is the requester" do
        let!(:user) { requester }
        it "deletes rental request" do
          request = instance_double("RentalRequest", id: "1", listing: listing, requester: requester)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          expect(request).to receive(:destroy)
          delete :destroy, params: {id: request.id}, session: {user_id: user.id}
        end
        it "redirects to listing requests page" do
          delete :destroy, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
        it "redirects to listings page if request does not exist" do
          expect(RentalRequest).to receive(:find_by).and_return(nil)
          delete :destroy, params: {id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
      end
      context "user is not the requester" do
        let!(:user) { owner }
        it "does not delete request if user is not the requester" do
          request = instance_double("RentalRequest", id: 1, listing: listing, requester: requester)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          expect(request).to_not receive(:destroy)
          delete :destroy, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "POST #approve" do
      context "user is the listing owner" do
        let!(:user) { owner }
        it "creates a new rental from request" do
          request = instance_double("RentalRequest", id: 1, listing: listing, listing_id: listing.id)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          expect(request).to receive(:approve)
          post :approve, params: {id: request.id}, session: {user_id: user.id}
        end
        it "redirects to listings page if request does not exist" do
          expect(RentalRequest).to receive(:find_by).and_return(nil)
          post :approve, params: {id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
        it "redirects to request page" do
          post :approve, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path(listing.id)
        end
      end
      context "user is not the listing owner" do
        let!(:user) { requester }
        it "redirects to listing page" do
          post :approve, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

    describe "POST #decline" do
      context "user is the listing owner" do
        let!(:user) { owner }
        it "creates a new rental from request" do
          request = instance_double("RentalRequest", id: 1, listing: listing, listing_id: listing.id)
          expect(RentalRequest).to receive(:find_by).and_return(request)
          expect(request).to receive(:decline)
          post :decline, params: {id: request.id}, session: {user_id: user.id}
        end
        it "redirects to listings page if request does not exist" do
          expect(RentalRequest).to receive(:find_by).and_return(nil)
          post :decline, params: {id: 0}, session: {user_id: user.id}
          expect(response).to redirect_to listings_path
        end
        it "redirects to request page" do
          post :decline, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_rental_requests_path listing.id
        end
      end
      context "user is not the listing owner" do
        let!(:user) { requester }
        it "redirects to listing page" do
          post :decline, params: {id: request.id}, session: {user_id: user.id}
          expect(response).to redirect_to listing_path listing.id
        end
      end
    end

  end

  context "user is not logged in" do
    describe "GET #index" do
      it "redirects to login page" do
        get :index, params: {listing_id: 1}
        expect(response).to redirect_to login_path
      end
    end
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
        get :edit, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "PATCH #update" do
      it "redirects to login page" do
        patch :update, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "DELETE #destroy" do
      it "redirects to login page" do
        delete :destroy, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "POST #approve" do
      it "redirects to login page" do
        post :approve, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "POST #decline" do
      it "redirects to login page" do
        post :decline, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#rental_request_params" do

    controller = RentalRequestsController.new

    it "raises ParameterMissing error if there is no rental_request parameter" do
      params_hash = { fake: { fake: "hello" } }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      expect{controller.send(:rental_request_params)}.to raise_error ActionController::ParameterMissing
    end

    it "returns only listing parameters with others filtered" do
      params_hash = {
        rental_request: { pick_up_time: "2030-10-28 00:00:00 UTC",
                          return_time: "2030-10-29 00:00:00 UTC",
                          payment_method: "blood",
                          junk: "junk" },
        gunk: { hunk: "hunk" }
      }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      rental_request_params = controller.send :rental_request_params
      expect(rental_request_params).to include :pick_up_time, :return_time, :payment_method
      expect(rental_request_params).to_not include  :junk, :gunk, :hunk
    end

  end

end
