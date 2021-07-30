class CommentsController < ApplicationController
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
    Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: 1)
    redirect_back(fallback_location: root_path)
  end

  def downvote
    Vote.new(user_id: current_user.id, votable_type: "Comment", votable_id: params[:id], value: -1)
    redirect_back(fallback_location: root_path)
  end
end