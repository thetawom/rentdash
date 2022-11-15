class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  def require_login
    redirect_to login_path unless session.include? :user_id
  end

  def current_user
    if session[:user_id]
      user = User.find_by id: session[:user_id]
      if user.nil?
        session[:user_id] = nil
      else
        @current_user ||= user
      end
    end
  end
end
