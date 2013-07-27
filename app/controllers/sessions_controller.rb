class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      # error and signin form
      flash.now[:error] = "We couldn't find you! Please try again or signup"
      render 'new'
    end
  end

  def destroy
  end
end
