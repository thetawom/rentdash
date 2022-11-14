require 'rails_helper'

RSpec.describe RentalsController, type: :controller do

  context "user is logged in" do
    let(:user) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: user) }

    describe "GET #index" do
      it "renders the index template" do
        get :index, session: {user_id: user.id}
        expect(response).to render_template "index"
      end

      it "assigns @rentals" do
        rental = request.approve
        get :index, session: {user_id: user.id}
        expect(assigns(:rentals)).to include rental
      end
    end

    describe "GET #show" do
      let(:rental) { request.approve }
      it "renders the show template" do
        get :show, params: {id: rental.id}, session: {user_id: user.id}
        expect(response).to render_template "show"
      end
      it "assigns @rental by id" do
        get :show, params: {id: rental.id}, session: {user_id: user.id}
        expect(assigns(:rental)).to eq rental
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
  end

end