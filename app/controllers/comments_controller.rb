class CommentsController < ApplicationController
  before_action :is_logged_in?, except: %i(show)
  before_action :set_comment, only: %i(show destroy)
  before_action :own_comment, only: [:destroy]

  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(
      content: params[:comment][:content],
      post_id: params[:comment][:post_id],
      parent_comment_id: params[:comment][:parent_comment_id]
    )

    @comment.author_id = current_user.id

    if @comment.save
      redirect_to post_url(@comment.post_id)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def show
    render :show
  end

  def destroy
    @comment.destroy
    flash[:notice] = ["comment has been deleted"]
    redirect_to post_url(@comment.post_id)
  end

  def upvote
    v = Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: 1)
    v.save!
    if params[:post_id]
      redirect_to post_url(params[:post_id])
    elsif params[:comment_id]
      redirect_to comment_url(params[:comment_id])
    else
      redirect_to user_url(params[:user_id])
    end
  end

  def downvote
    v = Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: -1)
    v.save!
    if params[:post_id]
      redirect_to post_url(params[:post_id])
    elsif params[:comment_id]
      redirect_to comment_url(params[:comment_id])
    else
      redirect_to user_url(params[:user_id])
    end
  end

  private
    def set_comment
      @comment = Comment.includes(:post).find_by(id: params[:id])
    end

    def own_comment
      if current_user != @comment.author && current_user != @comment.post.author
        flash[:notice] = ["Only the Author can edit a comment"]
        redirect_to post_url(@comment.post)
      end
    end
end