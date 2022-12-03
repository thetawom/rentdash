class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def show
  end

  def new
    @user = User.new
    @user.update user_params if params.has_key? :user
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_path @user.id
    else
      redirect_to new_user_path user: user_params
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end

end