class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      flash[:success] = "Upload Successful!"
    else
      flash[:error] = "Your comment must be under 200 characters and can't be blank."
    end
      redirect_to track_path(@comment.track)
  end

  def destroy
  end
end
