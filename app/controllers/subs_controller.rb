class SubsController < ApplicationController
  before_action :set_sub, only: %i(show edit update destroy)
  before_action :own_sub, only: [:edit, :update]

  def index 
    @subs = Sub.all
    render :index
  end

  def show
    render :show
  end

  def new 
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)

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
    flash[:notice] = "#{@sub.title} has been deleted"
    redirect_to :subs
  end

  private

  def set_sub 
    @sub = Sub.find_by(id: params[:id])
  end

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def own_sub
    @current_user.id == @sub.moderator_id
  end
end