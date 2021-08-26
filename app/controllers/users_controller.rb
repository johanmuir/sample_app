class UsersController < ApplicationController

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
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
