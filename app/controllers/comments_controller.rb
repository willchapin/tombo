class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
    else
      flash[:error] = "Your comment must be under 2000 characters and can't be blank."
    end
      redirect_to track_path(@comment.track)
  end

  def destroy
   @comment = Comment.find(params[:id]).delete
   flash[:success] = "Comment has been deleted!"
   redirect_to track_path(@comment.track)
  end
end
