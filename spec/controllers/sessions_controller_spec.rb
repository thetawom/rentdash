require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#create" do
    it "sets session user_id if user enters valid credentials" do
      user = instance_double("User",
                             id: "1", email: "uni123@columbia.edu", password: "password")
      expect(user).to receive(:authenticate).with(user.password).and_return(true)
      allow(User).to receive(:find_by).with(email: user.email).and_return(user)
      post :create, params: {email: user.email, password: user.password}
      expect(assigns(:user)).to eql user
      expect(session[:user_id]).to eql user.id
      expect(response).to redirect_to root_path
    end
    it "returns user to login page if user cannot be found" do
      allow(User).to receive(:find_by).and_return(nil)
      post :create
      expect(response).to redirect_to login_path
    end
    it "returns user to login page if user credentials are incorrect" do
      user = instance_double("User")
      expect(user).to receive(:authenticate).and_return(false)
      allow(User).to receive(:find_by).and_return(user)
      post :create
      expect(response).to redirect_to login_path
    end
  end
  describe "#destroy" do
    it "logs out user" do
      session[:user_id] = "1"
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to login_path
    end
  end
end
