class TracksController < ApplicationController

  before_filter :signed_in_user
  before_filter :authorized, only: [:delete, :update]

  def create
    @track = current_user.tracks.build(params[:track])
    if @track.save
      flash[:success] = "Upload Successful!"
      redirect_to root_path
    else
      flash[:error] = "I'm sorry, please upload your track in .ogg format."
      redirect_to root_path
    end
  end

  def show
    @track = Track.find(params[:id])
    @user = User.find(@track.user)
  end

  def destroy
   @track = Track.find(params[:id]).delete
   flash[:success] = "#{@track.title} has been deleted!"
   redirect_to root_path
  end

  def edit
    @track = Track.find(params[:id])
  end

  def update
    if @track.update_attributes(params[:track])
      flash[:success] = "#{@track.title} updated!"
      redirect_to track_path
    else 
      render 'edit'
    end
  end

  private

    def authorized
      @track = current_user.tracks.find_by_id(params[:id])
      redirect_to root_path if @track.nil?
    end

end
