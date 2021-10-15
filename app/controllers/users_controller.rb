class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    if logged_in?
        @user = User.find(params[:id])
    else
      flash[:danger]="You're not allowed to navigate to the requested url"
      redirect_to root_url
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      
      reset_session
      log_in @user
      flash[:success]="Welcome to the Sample App!"
      
      redirect_to @user
      
    else
      render 'new'
    end
  end
  
  def edit

  end
  
  def update
    if(@user.update(user_params))
      flash[:success]="User information updated successfully"
      
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #Before Filters
    
    #Confirms a logged in user
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      
      redirect_to login_url unless current_user?(@user)
      
    end
    
end
