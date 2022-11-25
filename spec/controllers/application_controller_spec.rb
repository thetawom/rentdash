require "rails_helper"


RSpec.describe ApplicationController, type: :controller do

  controller do
    def index
      current_user
      head :ok
    end
  end

  describe "#current_user" do

    it "sets current_user to user corresponding to session user_id" do
      user = instance_double("User", id: 123)
      expect(User).to receive(:find_by).with(id: user.id).and_return(user)
      get :index, session: {user_id: user.id}
      expect(assigns(:current_user)).to eq user
    end

    it "clears session user if user no longer exists" do
      expect(User).to receive(:find_by).and_return(nil)
      get :index, session: {user_id: 1}
      expect(session[:user_id]).to be_nil
    end

  end

end