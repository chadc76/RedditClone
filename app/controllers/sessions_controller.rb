class SessionsController < ApplicationController
  before_action :logged_in?, except: [:destroy]

  def new
    @user = User.new
    render :new
  end

  def create 
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user.nil?
      flash.now[:errors] = ["Username and Password did not match"]
      @user = User.new
      render :new
    else
      log_in_user!(@user)      
    end
  end

  def destroy
    if !current_user
      redirect_to new_session_url
      return
    end

    log_out_user!
    redirect_to new_session_url
  end
end
