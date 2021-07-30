class UsersController < ApplicationController
  before_action :logged_in?, only: [:new, :create]

  def new 
    @user = User.new
    render :new
  end

  def create 
    @user = User.new(user_params)

    if @user.save
      log_in_user!(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.includes(:subs).includes(posts: :votes).includes(comments: :votes).includes(:subscriptions).friendly.find(params[:id])

    @posts = @user.posts.sort_by{|p| p.hotness }.reverse

    comments = @user.comments.sort_by{|c| c.hotness }.reverse
    page = params[:page] || 1
    @comments = Kaminari.paginate_array(comments).page(page).per(10)
    
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end