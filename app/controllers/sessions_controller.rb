class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
    
    reset_session
    log_in(@user)
    redirect_to @user
    
    else
    flash.now[:danger]="Email and/or Password not found"  
    render 'new'
    end
  end
  
  def destroy
    logout
    redirect_to root_url
  end
end
