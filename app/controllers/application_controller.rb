class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  def require_login
    redirect_to new_session_path unless session.include? :user_id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
