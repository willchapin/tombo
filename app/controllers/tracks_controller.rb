class TracksController < ApplicationController

  before_filter :signed_in_user, only: [:delete]
  before_filter :authorized, only: [:delete]

  def create
    @track = current_user.tracks.build(params[:track])
    puts params[:track]
    if @track.save
      flash[:success] = "Upload Successful!"
      redirect_to root_path
    else
      flash[:error] = "I'm sorry, please upload your track in .ogg format."
      redirect_to root_path
    end

  end

  def destroy
   @track = Track.find(params[:id]).delete
   flash[:success] = "#{@track.title} has been deleted!"
   redirect_to root_path
  end


  private

    def authorized
      @track = Track.find(params[:id])
      @user = @track.user
      redirect_to root_path unless current_user?(@user)
    end

    def signed_in_user
      redirect_to signin_path unless signed_in? 
    end


end
