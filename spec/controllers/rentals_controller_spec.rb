require 'rails_helper'

RSpec.describe RentalsController, type: :controller do

  context "user is logged in" do

    let(:user) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: user) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing)}

    describe "GET #index" do
      it "renders the index template" do
        get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
        expect(response).to render_template "index"
      end

      it "assigns @rental_requests" do
        get :index, params: {listing_id: listing.id}, session: {user_id: user.id}
        expect(assigns(:listing)).to eq listing
        expect(assigns(:rental_requests)).to eq [request]
      end
    end

    describe "GET #show" do
      it "renders the show template" do
        get :show, params: {id: request.id}, session: {user_id: user.id}
        expect(response).to render_template "show"
      end

      it "assigns @rental_request" do
        get :show, params: {id: request.id}, session: {user_id: user.id}
        expect(assigns(:rental_request)).to eq request
        expect(assigns(:listing)).to eq listing
      end

      it "redirects to my requests page if user is neither owner nor requester" do
        other_request = FactoryBot.create(:rental_request)
        get :show, params: {id: other_request.id}, session: {user_id: user.id}
      end
    end

    describe "GET #new" do
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

    describe "POST #create" do
      it "creates new rental request if params are valid" do
        rental_request = instance_double("RentalRequest", id: "1")
        allow(rental_request).to receive(:valid?).and_return(true)
        allow(rental_request).to receive(:listing_id=)
        allow(rental_request).to receive(:requester=)
        expect(rental_request).to receive(:save)
        expect(RentalRequest).to receive(:new).and_return(rental_request)
        allow_any_instance_of(RentalRequestsController).to receive(:rental_request_params)
        post :create, params: {listing_id: listing.id}, session: {user_id: user.id}
        expect(response).to redirect_to rental_request_path rental_request.id
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
        post :create, params:{listing_id:listing.id}, session: {user_id: user.id}
        expect(flash[:errors]).to_not be_nil
        expect(response).to redirect_to new_listing_rental_request_path
      end
    end

    describe "DELETE #destroy" do
      it "deletes rental request" do
        request = instance_double("RentalRequest", id: "1", listing: listing, requester: user)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to receive(:destroy)
        delete :destroy, params: {id: request.id}, session: {user_id: user.id}
      end

      it "redirects to my requests page" do
        delete :destroy, params: {id: request.id}, session: {user_id: request.requester.id}
        expect(response).to redirect_to my_requests_path
      end

      it "does not delete request if user is not the requester" do
        requester = instance_double("User")
        listing = instance_double("Listing", owner: requester)
        request = instance_double("RentalRequest", id: "1", listing: listing, requester: requester)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to_not receive(:destroy)
        delete :destroy, params: {id: request.id}, session: {user_id: user.id}
        expect(response).to redirect_to my_requests_path
      end
    end

    describe "GET #mine" do
      let(:other_listing) { FactoryBot.create(:listing) }
      let(:my_request) { FactoryBot.create(:rental_request, listing: other_listing, requester: user) }

      it "assigns @requests only with requests made by current user" do
        get :mine, session: {user_id: user.id}
        expect(response).to render_template "mine"
        expect(assigns(:rental_requests)).to include my_request
        expect(assigns(:rental_requests)).to_not include request
      end
    end

    describe "POST #approve" do
      it "creates a new rental from request" do
        request = instance_double("RentalRequest", id: "1", listing: listing, listing_id: listing.id)
        expect(RentalRequest).to receive(:find_by).and_return(request)
        expect(request).to receive(:approve)
        post :approve, params: {id: request.id}, session: {user_id: user.id}
      end

      it "redirects to request page if user is the owner" do
        post :approve, params: {id: request.id}, session: {user_id: user.id}
        expect(response).to redirect_to listing_rental_requests_path(listing.id)
      end

      it "redirects to request page if user is not the owner" do
        post :approve, params: {id: request.id}, session: {user_id: request.requester.id}
        expect(response).to redirect_to rental_request_path(request.id)
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
                                                    rental_request: { pick_up_date: "2022-10-28 00:00:00 UTC", return_date: "2022-10-29 00:00:00 UTC" },
                                                    gunk: { hunk: "hunk" }
                                                  })
        allow(controller).to receive(:params).and_return(params)
        rental_request_params = controller.send(:rental_request_params)
        expect(rental_request_params).to include(:pick_up_date, :return_date)
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
    describe "GET #show" do
      it "redirects to login page" do
        get :show, params: {id: 1}
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
    describe "DELETE #destroy" do
      it "redirects to login page" do
        delete :destroy, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
    describe "GET #mine" do
      it "redirects to login page" do
        get :mine
        expect(response).to redirect_to login_path
      end
    end
  end

end
