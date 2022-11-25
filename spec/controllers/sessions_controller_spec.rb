require "rails_helper"

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template "new"
    end
  end

  describe "POST #create" do
    context "user exists" do
      let(:user) { FactoryBot.create(:user) }
      it "sets session user_id if credentials are valid" do
        post :create, params: {email: user.email, password: user.password}
        expect(session[:user_id]).to eql user.id
        expect(response).to redirect_to root_path
      end
      it "redirects to login page if credentials are invalid" do
        post :create, params: {email: user.email, password: "wrong_password"}
        expect(response).to redirect_to login_path
      end
    end
    it "redirects to login page if user cannot be found" do
      allow(User).to receive(:find_by).and_return(nil)
      post :create
      expect(response).to redirect_to login_path
    end
  end

  describe "DELETE #destroy" do
    it "clears session user_id and redirects to login page" do
      session[:user_id] = "1"
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
    it "redirects to the login page" do
      delete :destroy
      expect(response).to redirect_to login_path
    end
  end

end
