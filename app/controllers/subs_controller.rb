class SubsController < ApplicationController
  before_action :set_sub, only: %i(show edit update destroy)
  before_action :own_sub, only: [:edit, :update]
  before_action :is_logged_in?, except: %i(index show)

  def index 
    if !current_user
      @subs = {all_subs: Sub.all}
    else
      @subs = current_user.all_subs
    end

    render :index
  end

  def show
    posts = @sub.posts.sort_by{|p| p.score }.reverse
    page = params[:page] || 1
    @posts = Kaminari.paginate_array(posts).page(page).per(10)
    render :show
  end

  def new 
    @sub = Sub.new.decorate
    render :new
  end

  def create
    @sub = Sub.new(sub_params).decorate
    @sub.moderator_id = current_user.id

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update

    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub.destroy
    flash[:notice] = ["#{@sub.title} has been deleted"]
    redirect_to :subs
  end

  def subscribe
    sub_id = Sub.find_by(slug: params[:id]).id
    s = Subscription.new(user_id: current_user.id, sub_id: sub_id)
    if s.save
      flash[:notice] = ["Subscribed!"]
      redirect_to sub_url(params[:id])
    else
      flash[:errors] = s.errors.full_messages
      redirect_to sub_url(params[:id])
    end
  end

  def unsubscribe
    sub_id = Sub.find_by(slug: params[:id]).id
    s = Subscription.find_by(user_id: current_user.id, sub_id: sub_id)
    s.destroy!
    
    flash[:notice] = ["UnSubscribed!"]
    redirect_to sub_url(params[:id])
  end

  private

  def set_sub 
    @sub = Sub.includes(posts: :votes).friendly.find(params[:id]).decorate
  end

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def own_sub
    if current_user && current_user.id != @sub.moderator_id
      flash[:notice] = ["Only the Moderator can edit a sub"]
      redirect_to sub_url(@sub)
    end
  end
end