class UsersController < ApplicationController

  before_filter :authorized, only: [:edit, :update]
  before_filter :signed_in_user, only: [:index]
  before_filter :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
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

  def destroy
    @user = User.find(params[:id]).delete
    flash[:success] = "#{@user.name} has been destroyed!"
    redirect_to users_path
  end

  private

    def authorized
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def signed_in_user
      redirect_to signin_path unless signed_in? 
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
