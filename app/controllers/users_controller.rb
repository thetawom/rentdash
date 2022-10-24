class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def show
  end

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_path @user.id
    else
      flash[:errors] = @user.errors
      redirect_to new_user_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end

end