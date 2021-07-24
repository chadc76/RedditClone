class ApplicationController < ActionController::Base
  helper_method :current_user

  def log_in_user!(user)
    session[:session_token] = user.session_token
    redirect_to subs_url
  end

  def log_out_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in? 
    if current_user
      redirect_to user_url(current_user)
      return
    end
  end

  def is_logged_in? 
    if !current_user
      flash[:notice] = ["You must be logged in to do this"]
      redirect_to new_session_url
      return
    end
  end
end
