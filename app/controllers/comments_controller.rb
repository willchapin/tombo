class CommentsController < ApplicationController

  before_filter :signed_in_user
  before_filter :authorized, only: [:destroy]

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
   @comment.delete
   flash[:success] = "Comment has been deleted!"
   redirect_to track_path(@comment.track)
  end


  private

    def authorized
      @comment = current_user.comments.find_by_id(params[:id])
      redirect_to root_path if @comment.nil?
    end
end
