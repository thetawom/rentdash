require 'rails_helper'

RSpec.describe RentalRequestsController, type: :controller do

  context "user is logged in" do

    let(:owner) { FactoryBot.create(:user) }
    let(:requester) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: owner) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: requester)}

    describe "GET #index" do

      let(:other_request) { FactoryBot.create(:rental_request, listing: listing) }
      let(:irrelevant_request) { FactoryBot.create(:rental_request) }

      it "renders the index template" do
        get :index, params: {listing_id: listing.id}, session: {user_id: owner.id}
        expect(response).to render_template "index"
      end

      it "assigns @rental_requests when user is the listing owner" do
        get :index, params: {listing_id: listing.id}, session: {user_id: owner.id}
        expect(assigns(:listing)).to eq listing
        expect(assigns(:rental_requests)).to include request
        expect(assigns(:rental_requests)).to include other_request
        expect(assigns(:rental_requests)).to_not include irrelevant_request
      end

      it "assigns @rental_requests when user is the requester" do
        get :index, params: {listing_id: listing.id}, session: {user_id: requester.id}
        expect(assigns(:rental_requests)).to include request
        expect(assigns(:rental_requests)).to_not include other_request
        expect(assigns(:rental_requests)).to_not include irrelevant_request
      end

    end

    describe "GET #new" do

      it "renders the new template" do
        get :new, params:{listing_id: listing.id}, session: {user_id: owner.id}
        expect(response).to render_template "new"
      end

      it "creates a blank rental request" do
        rental_request = instance_double("RentalRequest")
        allow(RentalRequest).to receive(:new).and_return rental_request
        get :new, params: {listing_id: listing.id}, session: {user_id: owner.id}
        expect(assigns(:listing)).to eq listing
        expect(assigns(:rental_request)).to eq rental_request
      end

    end

    describe "POST #create" do

      it "creates new rental request if params are valid" do
        rental_request = instance_double("RentalRequest", id: "1", listing: listing)
        allow(rental_request).to receive(:valid?).and_return(true)
        allow(rental_request).to receive(:listing_id=)
        allow(rental_request).to receive(:requester=)
        expect(rental_request).to receive(:save)
        expect(RentalRequest).to receive(:new).and_return(rental_request)
        allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
        post :create, params: {listing_id: listing.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

      it "redirects to new rental request page if params are invalid" do
        rental_request = instance_double("RentalRequest", listing_id:"1")
        errors = instance_double("ActiveModel::Errors")
        allow(rental_request).to receive(:listing_id=)
        allow(rental_request).to receive(:requester=)
        allow(rental_request).to receive(:valid?).and_return(false)
        allow(rental_request).to receive(:errors).and_return(errors)
        expect(rental_request).to receive(:save)
        expect(RentalRequest).to receive(:new).and_return(rental_request)
        allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
        post :create, params:{listing_id:listing.id}, session: {user_id: owner.id}
        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to new_listing_rental_request_path
      end

    end

    describe "GET #edit" do

      it "renders the edit template" do
        get :edit, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to render_template "edit"
      end

      it "assigns @rental_request by id" do
        get :edit, params: {id: request.id}, session: {user_id: requester.id}
        expect(assigns(:rental_request)).to eq request
      end

      it "redirects to listings page if request does not exist" do
        expect(RentalRequest).to receive(:find_by).and_return(nil)
        get :edit, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to listings_path
      end

      it "redirects to listing page if user is not requester" do
        get :edit, params: {id: request.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_path listing.id
      end

      it "redirects to listing requests page if request is no longer pending" do
        request.approve
        get :edit, params: {id: request.id}, session: {user_id: requester.id}
        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

    end

    describe "PATCH #update" do

      it "updates listing if params are valid" do
        request = instance_double("RentalRequest", id: "1", valid?: true, status: "pending", listing: listing, requester: requester)
        allow(request).to receive(:update)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
        post :update, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

      it "redirects to new listing page if params are invalid" do
        errors = instance_double("ActiveModel::Errors")
        request = instance_double("RentalRequest", id: "1", valid?: false, status: "pending", listing: listing, requester: requester, errors: errors)
        allow(request).to receive(:update)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
        post :update, params: {id: request.id}, session: {user_id: requester.id}
        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to new_listing_rental_request_path listing.id
      end

      it "redirects to listings page if request does not exist" do
        expect(RentalRequest).to receive(:find_by).and_return(nil)
        post :update, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to listings_path
      end

      it "redirects to listing page if user is not requester" do
        post :update, params: {id: request.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_path listing.id
      end

      it "redirects to listing requests page if request is no longer pending" do
        request.approve
        post :update, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

    end

    describe "DELETE #destroy" do

      it "deletes rental request" do
        request = instance_double("RentalRequest", id: "1", listing: listing, requester: requester)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to receive(:destroy)
        delete :destroy, params: {id: request.id}, session: {user_id: requester.id}
      end

      it "redirects to listing requests page" do
        delete :destroy, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

      it "redirects to listings page if request does not exist" do
        expect(RentalRequest).to receive(:find_by).and_return(nil)
        delete :destroy, params: {id: 0}, session: {user_id: requester.id}
        expect(response).to redirect_to listings_path
      end

      it "does not delete request if user is not the requester" do
        request = instance_double("RentalRequest", id: "1", listing: listing, requester: requester)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to_not receive(:destroy)
        delete :destroy, params: {id: request.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_path listing.id
      end

    end

    describe "POST #approve" do

      it "creates a new rental from request" do
        request = instance_double("RentalRequest", id: "1", listing: listing, listing_id: listing.id)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to receive(:approve)
        post :approve, params: {id: request.id}, session: {user_id: owner.id}
      end

      it "redirects to listings page if request does not exist" do
        expect(RentalRequest).to receive(:find_by).and_return(nil)
        post :approve, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to listings_path
      end

      it "redirects to request page if user is the owner" do
        post :approve, params: {id: request.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_rental_requests_path(listing.id)
      end

      it "redirects to listing page if user is not the owner" do
        post :approve, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to redirect_to listing_path listing.id
      end

    end

    describe "POST #decline" do

      it "creates a new rental from request" do
        request = instance_double("RentalRequest", id: "1", listing: listing, listing_id: listing.id)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to receive(:decline)
        post :decline, params: {id: request.id}, session: {user_id: owner.id}
      end

      it "redirects to listings page if request does not exist" do
        expect(RentalRequest).to receive(:find_by).and_return(nil)
        post :decline, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to listings_path
      end

      it "redirects to request page if user is the owner" do
        post :decline, params: {id: request.id}, session: {user_id: owner.id}
        expect(response).to redirect_to listing_rental_requests_path listing.id
      end

      it "redirects to listing page if user is not the owner" do
        post :decline, params: {id: request.id}, session: {user_id: requester.id}
        expect(response).to redirect_to listing_path listing.id
      end

    end

    describe "#rental_request_params" do

      controller = RentalRequestsController.new

      it "raises ParameterMissing error if there is no user parameter" do
        params = ActionController::Parameters.new({ fake: { fake: "hello" } })
        allow(controller).to receive(:params).and_return(params)
        expect{controller.send(:rental_request_params)}.to raise_error(ActionController::ParameterMissing)
      end

      it "returns only listing parameters with others filtered" do
        params = ActionController::Parameters.new({
                                                    rental_request: { pick_up_time: "2022-10-28 00:00:00 UTC", return_time: "2022-10-29 00:00:00 UTC" },
                                                    gunk: { hunk: "hunk" }
                                                  })
        allow(controller).to receive(:params).and_return(params)
        rental_request_params = controller.send(:rental_request_params)
        expect(rental_request_params).to include(:pick_up_time, :return_time)
        expect(rental_request_params).to_not include(:junk)
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

end
