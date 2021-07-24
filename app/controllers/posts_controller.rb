class PostsController < ApplicationController
  before_action :set_posts, only: %i(show edit update destroy)

  def show
    render :show
  end

  def new 
    @post.new.decorate
    render :new
  end

  def create
    @post.new(post_params).decorate
    @post.author_id = current_user.id

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit 
    render :edit
  end

  def update
    if @post.update(post_params).decorate
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = ["Post destroyed"]
    redirect_to sub_url(@post.sub_id)
  end

  private

  def set_posts 
    @post Post.find_by(id: params[:id]).decorate
  end

  def post_params
    params.require(:post).permit(:title, :url :content, :sub_id)
  end
end
