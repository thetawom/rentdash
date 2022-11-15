require 'rails_helper'

RSpec.describe RentalsController, type: :controller do

  context "user is logged in" do
    let(:owner) { FactoryBot.create(:user) }
    let(:renter) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: owner) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: renter) }

    describe "GET #index" do

      it "renders the index template" do
        get :index, session: {user_id: owner.id}
        expect(response).to render_template "index"
      end

      it "assigns @rentals" do
        rental = request.approve
        get :index, session: {user_id: renter.id}
        expect(assigns(:rentals)).to include rental
      end

    end

    describe "GET #show" do

      let(:rental) { request.approve }

      it "renders the show template" do
        get :show, params: {id: rental.id}, session: {user_id: owner.id}
        expect(response).to render_template "show"
      end

      it "assigns @rental by id" do
        get :show, params: {id: rental.id}, session: {user_id: owner.id}
        expect(assigns(:rental)).to eq rental
      end

      it "redirects to my listings page if rental does not exist" do
        expect(Rental).to receive(:find_by).and_return(nil)
        get :show, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to my_listings_path
      end

      it "redirects to listing page if user is not owner or renter" do
        other_user = FactoryBot.create(:user)
        get :show, params: {id: rental.id}, session: {user_id: other_user.id}
        expect(response).to redirect_to rentals_path
      end

    end

    describe "GET #edit" do

      let(:rental) { request.approve }

      it "renders the edit template" do
        get :edit, params: {id: rental.id}, session: {user_id: owner.id}
        expect(response).to render_template "edit"
      end

      it "assigns @rental by id" do
        get :edit, params: {id: rental.id}, session: {user_id: owner.id}
        expect(assigns(:rental)).to eq rental
      end

      it "assigns @rental_request" do
        get :edit, params: {id: rental.id}, session: {user_id: owner.id}
        expect(assigns(:rental_request)).to eq request
      end

      it "redirects to my listings page if rental does not exist" do
        expect(Rental).to receive(:find_by).and_return(nil)
        get :edit, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to my_listings_path
      end

      it "redirects to listing page if user is not owner" do
        get :edit, params: {id: rental.id}, session: {user_id: renter.id}
        expect(response).to redirect_to listing_path rental.listing.id
      end

    end

    describe "PATCH #update" do

      let(:rental) { request.approve }

      it "updates rental if params are valid" do
        request = instance_double("RentalRequest", id: 1, valid?: true, listing: listing, requester: renter)
        rental = instance_double("Rental", id: 1, valid?: true, request: request, listing: listing, renter: renter)
        expect(rental).to receive(:update)
        expect(request).to receive(:update)
        expect(Rental).to receive(:find_by).and_return(rental)
        allow_any_instance_of(RentalsController).to receive :rental_params
        allow_any_instance_of(RentalsController).to receive :rental_request_params
        patch :update, params: {id: rental.id}, session: {user_id: owner.id}
        expect(flash[:success]).to_not be_nil
        expect(response).to redirect_to rental_path rental.id
      end

      it "redirects to rental page if rental params are invalid" do
        request_errors = instance_double("ActiveModel::Errors")
        rental_errors = instance_double("ActiveModel::Errors")
        errors = instance_double("ActiveModel::Errors")
        allow(rental_errors).to receive(:merge!).with(request_errors).and_return errors
        request = instance_double("RentalRequest", id: 1, valid?: true, listing: listing, requester: renter, errors: request_errors)
        rental = instance_double("Rental", id: 1, valid?: false, request: request, listing: listing, renter: renter, errors: rental_errors)
        expect(rental).to receive(:update)
        expect(request).to receive(:update)
        expect(Rental).to receive(:find_by).and_return(rental)
        allow_any_instance_of(RentalsController).to receive :rental_params
        allow_any_instance_of(RentalsController).to receive :rental_request_params
        patch :update, params: {id: rental.id}, session: {user_id: owner.id}
        expect(flash[:error]).to eq errors
        expect(response).to redirect_to edit_rental_path rental.id
      end

      it "redirects to rental page if rental params are invalid" do
        request_errors = instance_double("ActiveModel::Errors")
        rental_errors = instance_double("ActiveModel::Errors")
        errors = instance_double("ActiveModel::Errors")
        allow(rental_errors).to receive(:merge!).with(request_errors).and_return errors
        request = instance_double("RentalRequest", id: 1, valid?: false, listing: listing, requester: renter, errors: request_errors)
        rental = instance_double("Rental", id: 1, valid?: true, request: request, listing: listing, renter: renter, errors: rental_errors)
        expect(rental).to receive(:update)
        expect(request).to receive(:update)
        expect(Rental).to receive(:find_by).and_return(rental)
        allow_any_instance_of(RentalsController).to receive :rental_params
        allow_any_instance_of(RentalsController).to receive :rental_request_params
        patch :update, params: {id: rental.id}, session: {user_id: owner.id}
        expect(flash[:error]).to eq errors
        expect(response).to redirect_to edit_rental_path rental.id
      end

      it "redirects to my listings page if request does not exist" do
        expect(Rental).to receive(:find_by).and_return(nil)
        patch :update, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to my_listings_path
      end

      it "redirects to listing page if user is not listing owner" do
        patch :update, params: {id: rental.id}, session: {user_id: renter.id}
        expect(response).to redirect_to listing_path listing.id
      end

    end

    describe "POST #cancel" do

      let(:rental) { request.approve }

      it "updates the status of the rental to cancelled" do
        rental = instance_double("Rental", id: 1, listing: listing)
        expect(Rental).to receive(:find_by).and_return(rental)
        expect(rental).to receive(:update).with(status: "cancelled")
        post :cancel, params: {id: rental.id}, session: {user_id: owner.id}
      end

      it "redirects to the rental page" do
        post :cancel, params: {id: rental.id}, session: {user_id: owner.id}
        expect(response).to redirect_to rental_path rental.id
      end

      it "redirects to my listings page if rental does not exist" do
        expect(Rental).to receive(:find_by).and_return(nil)
        post :cancel, params: {id: 0}, session: {user_id: owner.id}
        expect(response).to redirect_to my_listings_path
      end

      it "redirects to listing page if user is not owner" do
        post :cancel, params: {id: rental.id}, session: {user_id: renter.id}
        expect(response).to redirect_to listing_path rental.listing.id
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
    describe "POST #cancel" do
      it "redirects to login page" do
        post :cancel, params: {id: 1}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#rental_params" do

    controller = RentalsController.new

    it "raises ParameterMissing error if there is no rental_request parameter" do
      params_hash = { fake: { fake: "hello" } }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      expect{controller.send(:rental_params)}.to raise_error ActionController::ParameterMissing
    end

    it "returns only listing parameters with others filtered" do
      params_hash = {
        rental: { status: "completed",
                  payment_method: "venmo",
                  junk: "junk" },
        gunk: { hunk: "hunk" }
      }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      rental_request_params = controller.send :rental_params
      expect(rental_request_params).to include :status, :payment_method
      expect(rental_request_params).to_not include :junk, :gunk, :hunk
    end

  end

  describe "#rental_request_params" do

    controller = RentalsController.new

    it "raises ParameterMissing error if there is no rental_request parameter" do
      params_hash = { fake: { fake: "hello" } }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      expect{controller.send(:rental_request_params)}.to raise_error ActionController::ParameterMissing
    end

    it "returns only listing parameters with others filtered" do
      params_hash = {
        rental_request: { pick_up_time: "2022-10-28 00:00:00 UTC",
                          return_time: "2022-10-29 00:00:00 UTC",
                          junk: "junk" },
        gunk: { hunk: "hunk" }
      }
      allow(controller).to receive(:params).and_return ActionController::Parameters.new params_hash
      rental_request_params = controller.send :rental_request_params
      expect(rental_request_params).to include :pick_up_time, :return_time
      expect(rental_request_params).to_not include :junk, :gunk, :hunk
    end

  end

end