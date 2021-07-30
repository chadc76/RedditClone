class PostsController < ApplicationController
  before_action :set_posts, only: %i(show edit update destroy)
  before_action :own_post, only: %i(edit update destroy)
  before_action :is_logged_in?, except: %i(show)

  def show
    @comments_by_parent_id = @post.comments_by_parent_id
    @comments_by_parent_id.each do |k, comments|
      new_comments = comments.sort_by { |comment| comment.score }.reverse
      @comments_by_parent_id[k] = new_comments
    end
    render :show
  end

  def new 
    @post = Post.new.decorate
    render :new
  end

  def create
    @post = Post.new(post_params).decorate
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
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = ["Post destroyed"]
    redirect_to subs_url
  end

  def upvote
    v = Vote.new(user_id: current_user.id, votable_type: "Post", votable_id: params[:id], value: 1)
    v.save!
    if params[:sub_id]
      redirect_to sub_url(params[:sub_id])
    else
      redirect_to post_url(params[:post_id])
    end
  end

  def downvote
    v = Vote.new(user_id: current_user.id, votable_type: "Post", votable_id: params[:id], value: -1)
    v.save!
    if params[:sub_id]
      redirect_to sub_url(params[:sub_id])
    else
      redirect_to post_url(params[:post_id])
    end
  end

  private

  def set_posts 
    @post = Post.includes(:author).includes(:subs).includes(comments: :votes).friendly.find(params[:id]).decorate
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def own_post
    if current_user && current_user.id != @post.author_id
      flash[:notice] = ["Only the Author can edit a post"]
      redirect_to post_url(@post)
    end
  end
end
