class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
      
  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page:20)
  end
  
  
  def show
    if logged_in?
        @user = User.find(params[:id])
        redirect_to root_url and return unless @user.activated?
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
      @user.send_activation_email
      flash[:info]="Please check you email to activate account"
      
      redirect_to root_path
      
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
  
  def destroy
    user_to_destroy = User.find(params[:id])
    user_to_destroy.destroy
    flash[:success]="User deleted"
      
    redirect_to users_path
    
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
      redirect_to login_path unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_path unless @current_user.admin? && @current_user != user_to_destroy
    end
    
end
