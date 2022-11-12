require 'rails_helper'

RSpec.describe RentalsController, type: :controller do

  context "user is logged in" do
    let(:user) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing) }
    let(:request) { FactoryBot.create(:rental_request, listing: listing, requester: user)}

    describe "GET #index" do
      it "renders the index template" do
        get :index, session: {user_id: user.id}
        expect(response).to render_template "index"
      end

      it "assigns @rental_requests" do
        rental = request.approve
        get :index, session: {user_id: user.id}
        expect(assigns(:rentals)).to include rental
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
  end

end