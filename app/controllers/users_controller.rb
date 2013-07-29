class UsersController < ApplicationController

  before_filter :authorized, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user 
      flash[:success] = "Tombo welcomes you!"
      redirect_to @user
    else 
      render 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated!"
      redirect_to @user
    else 
      render 'edit'
    end
  end

  private

    def authorized
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
