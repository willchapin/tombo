class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @track = current_user.tracks.build
    end
  end

  def contact
  end

  def about
  end

end
