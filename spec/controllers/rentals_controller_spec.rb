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
        get :edit, params: {id: rental.id}, session: {user_id: owner.id}
        expect(response).to redirect_to my_listings_path
      end

      it "redirects to listing page if user is not owner" do
        get :edit, params: {id: rental.id}, session: {user_id: renter.id}
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
        post :update, params: {id: 1}
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

end