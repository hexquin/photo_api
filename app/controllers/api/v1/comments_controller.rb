class Api::V1::CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.valid?
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end
  private
    def comment_params
      params.require(:comment).permit(:content, :owner, :photo_id)
    end
end
