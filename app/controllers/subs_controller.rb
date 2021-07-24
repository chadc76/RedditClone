class SubsController < ApplicationController
  before_action :set_sub, only: %i(show edit update destroy)
  before_action :own_sub, only: [:edit, :update]
  before_action :is_logged_in?, except: %i(index show)

  def index 
    @subs = Sub.all
    render :index
  end

  def show
    render :show
  end

  def new 
    @sub = Sub.new.decorate
    render :new
  end

  def create
    @sub = Sub.new(sub_params).decorate

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

    if @sub.update(sub_params).decorate
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

  private

  def set_sub 
    @sub = Sub.includes(:posts).find_by(id: params[:id]).decorate
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