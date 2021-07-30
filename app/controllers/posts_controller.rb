class PostsController < ApplicationController
  before_action :set_posts, only: %i(show edit update destroy remove_sub)
  before_action :own_post, only: %i(edit update destroy)
  before_action :is_logged_in?, except: %i(show)
  before_action :is_moderator?, only: [:remove_sub]

  def show
    @comments_by_parent_id = @post.comments_by_parent_id
    @comments_by_parent_id.each do |k, comments|
      new_comments = comments.sort_by { |comment| comment.hotness }.reverse
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
    post_id = Post.find_by(slug: params[:id]).id
    v = Vote.new(user_id: current_user.id, votable_type: "Post", votable_id: post_id, value: 1)
    v.save!
    if params[:sub_id]
      redirect_to sub_url(params[:sub_id])
    elsif params[:post_id]
      redirect_to post_url(params[:post_id])
    else
      redirect_to user_url(params[:user_id])
    end
  end

  def downvote
    post_id = Post.find_by(slug: params[:id]).id
    v = Vote.new(user_id: current_user.id, votable_type: "Post", votable_id: post_id, value: -1)
    v.save!
    if params[:sub_id]
      redirect_to sub_url(params[:sub_id])
    elsif params[:post_id]
      redirect_to post_url(params[:post_id])
    else
      redirect_to user_url(params[:user_id])
    end
  end

  def remove_sub
    PostSub.find_by(post_id: @post.id, sub_id: params[:sub_id]).destroy
    flash[:notice] = ["Post added to sub"]
    redirect_to sub_url(params[:sub_id])
  end

  private

  def set_posts 
    @post = Post.includes(:author).includes(:subs).includes(comments: [:votes, :author]).friendly.find(params[:id]).decorate
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def own_post
    if current_user != @post.author
      flash[:notice] = ["Only the Author can edit a post"]
      redirect_to post_url(@post)
    end
  end

  def is_moderator? 
    if current_user != Sub.find(params[:sub_id]).moderator
      flash[:notice] = ["you Are not the Moderator"]
      redirect_to post_url(@post)
    end
  end
end
