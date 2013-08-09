class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or(root_path)
    else
      # error and signin form
      flash.now[:error] = "We couldn't find you! Please #{ 
                            view_context.link_to('signup', signup_path, class: "flash") 
                             } or try again.".html_safe 
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
