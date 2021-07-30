class CommentsController < ApplicationController
  before_action :is_logged_in?, except: %i(show)
  
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
    @comment = Comment.find_by(id: params[:id])
    render :show
  end

  def upvote
    v = Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: 1)
    v.save!
    if params[:post_id]
      redirect_to post_url(params[:post_id])
    else
      redirect_to comment_url(params[:comment_id])
    end
  end

  def downvote
    v = Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: -1)
    v.save!
    if params[:post_id]
      redirect_to post_url(params[:post_id])
    else
      redirect_to comment_url(params[:comment_id])
    end
  end
end