require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#create" do
    user_attrs = {
      id: "1",
      email: "uni123@columbia.edu",
      password: "password"
    }
    it "redirects to root and sets session user_id if user credentials are valid" do
      user = instance_double("User", user_attrs)
      expect(user).to receive(:authenticate).with(user.password).and_return(true)
      allow(User).to receive(:find_by).with(email: user.email).and_return(user)
      post :create, params: {email: user.email, password: user.password}
      expect(session[:user_id]).to eql user.id
      expect(response).to redirect_to root_path
    end
    it "redirects to login page if user cannot be found" do
      allow(User).to receive(:find_by).and_return(nil)
      post :create
      expect(response).to redirect_to login_path
    end
    it "redirects to login page if user credentials are invalid" do
      user = instance_double("User")
      expect(user).to receive(:authenticate).and_return(false)
      allow(User).to receive(:find_by).and_return(user)
      post :create
      expect(response).to redirect_to login_path
    end
  end

  describe "#destroy" do
    it "clears session user_id and redirects to login page" do
      session[:user_id] = "1"
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to login_path
    end
  end

end
