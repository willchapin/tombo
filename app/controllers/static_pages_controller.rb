class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @track = current_user.tracks.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def contact
  end

  def about
  end

end
