class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @standup = Standup.find(params[:standup_id])
    @comment = @standup.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to standup_path(@standup), notice: "Comment added!"
    else
      redirect_to standup_path(@standup), alert: "Comment cannot be empty."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end