require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "#create" do
    it "creates new user if params are valid" do
      user = instance_double("User", id: "1")
      allow(user).to receive(:valid?).and_return(true)
      expect(User).to receive(:create).and_return(user)
      allow_any_instance_of(UsersController).to receive(:user_params)
      post :create
      expect(session[:user_id]).to eql user.id
      expect(response).to redirect_to user_path user.id
    end
    it "redirects to registration page if params are invalid" do
      user = instance_double("User")
      errors = instance_double("ActiveModel::Errors")
      allow(user).to receive(:valid?).and_return(false)
      allow(user).to receive(:errors).and_return(errors)
      expect(User).to receive(:create).and_return(user)
      allow_any_instance_of(UsersController).to receive(:user_params)
      post :create
      expect(flash[:errors]).to_not be_nil
      expect(response).to redirect_to new_user_path
    end
  end

  describe "#user_params" do
    controller = UsersController.new
    it "raises ParameterMissing error if there is no user parameter" do
      params = ActionController::Parameters.new({ fake: { fake: "hello" } })
      allow(controller).to receive(:params).and_return(params)
      expect{controller.send(:user_params)}.to raise_error(ActionController::ParameterMissing)
    end
    it "returns only user parameters with others filtered" do
      params = ActionController::Parameters.new({
                                                  user: { email: "uni123@columbia.edu", first_name: "Frankie", junk: "Junk", },
                                                  gunk: { hunk: "hunk" }
                                                })
      allow(controller).to receive(:params).and_return(params)
      user_params = controller.send(:user_params)
      expect(user_params).to include(:email, :first_name)
      expect(user_params).to_not include(:junk)
    end
  end

end
