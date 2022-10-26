require 'rails_helper'

RSpec.describe ListingsController, type: :controller do

  context "user is registered and is the listing owner" do
    let(:user) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing, owner: user) }

    describe "GET #index" do
      it "renders the index template" do
        get :index, session: {user_id: user.id}
        expect(response).to render_template "index"
      end
      it "assigns @listings" do
        allow(Listing).to receive(:all).and_return [listing]
        get :index, session: {user_id: user.id}
        expect(assigns(:listings)).to eq [listing]
      end
    end

    describe "GET #show" do
      it "renders the show template" do
        get :show, params: {id: listing.id}, session: {user_id: user.id}
        expect(response).to render_template "show"
      end
      it "assigns @listing by id" do
        get :show, session: {user_id: 1}, params: {id: listing.id}
        expect(assigns(:listing)).to eq listing
      end
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new, session: {user_id: user.id}
        expect(response).to render_template "new"
      end
      it "creates a blank listing" do
        listing = instance_double("Listing")
        allow(Listing).to receive(:new).and_return listing
        get :new, session: {user_id: user.id}
        expect(assigns(:listing)).to eq listing
      end
    end

    describe "POST #create" do
      pending
    end

    describe "GET #edit" do
      it "renders the edit template" do
        get :edit, params: {id: listing.id}, session: {user_id: user.id}
        expect(response).to render_template "edit"
      end
      it "assigns @listing by id" do
        get :show, session: {user_id: 1}, params: {id: listing.id}
        expect(assigns(:listing)).to eq listing
      end
    end

    describe "PATCH #update" do
      pending
    end

    describe "DELETE #destroy" do
      pending
    end

  end

  context "user is registered but is not the listing owner" do
    let(:user) { FactoryBot.create(:user) }
    let(:listing) { FactoryBot.create(:listing) }
    describe "GET #edit" do
      it "redirects to listings page" do
        get :edit, params: {id: listing.id}, session: {user_id: user.id}
        expect(response).to redirect_to listings_path
      end
    end
    describe "PATCH #update" do
      it "redirects to listings page" do
        patch :update, params: {id: listing.id}, session: {user_id: user.id}
        expect(response).to redirect_to listings_path
      end
    end
    describe "DELETE #destroy" do
      it "redirects to listings page" do
        delete :destroy, params: {id: listing.id}, session: {user_id: user.id}
        expect(response).to redirect_to listings_path
      end
    end
  end

  context "user is not registered" do
    describe "GET #index" do
      it "redirects to login page" do
        get :index
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
        get :new
        expect(response).to redirect_to login_path
      end
    end
    describe "POST #create" do
      it "redirects to login page" do
        post :create, params: {id: 1}
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
  end

end
