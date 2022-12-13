require "rails_helper"

RSpec.describe User, type: :model do

  describe "#validate" do
    it "should return false when user is missing attributes" do
      @user = User.create(email: "uni123@columbia.edu")
      expect(@user.valid?).to eq false
      expect(@user.errors[:email]).to be_empty
      expect(@user.errors[:first_name]).to_not be_empty
      expect(@user.errors[:last_name]).to_not be_empty
      expect(@user.errors[:password]).to_not be_empty
    end
    it "should return false when user passwords do not match" do
      @user = User.create(email: "uni123@columbia.edu",
                       first_name: "Frankie",
                       last_name: "Valli",
                       password: "password",
                       password_confirmation: "password2")
      expect(@user.valid?).to eq false
      expect(@user.errors[:password_confirmation]).to_not be_empty
    end
    it "should return false when user email is already taken" do
      User.create(email: "uni123@columbia.edu",
                  first_name: "Frankie",
                  last_name: "Valli",
                  phone: "1234567890",
                  password: "password",
                  password_confirmation: "password")
      @user = User.create(email: "uni123@columbia.edu",
                       first_name: "Bob",
                       last_name: "Gaudio",
                       phone: "1234567890",
                       password: "password",
                       password_confirmation: "password")
      expect(@user.valid?).to eq false
      expect(@user.errors[:email]).to_not be_empty
    end
  end

  describe "#welcome" do
    it "should return a welcome message containing the user's first name" do
      @user = User.new(first_name: "Frankie", last_name: "Valli")
      expect(@user.welcome).to include "Frankie"
    end
  end

  describe "#full_name" do
    it "should return the full name of the user" do
      @user = User.new(first_name: "Frankie", last_name: "Valli")
      expect(@user.full_name).to eq "Frankie Valli"
    end
  end

end
