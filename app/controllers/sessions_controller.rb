class SessionsController < ApplicationController
  
  def new
    redirect_to ideas_path if current_user
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to ideas_path
      flash[:success] = "You successfully logged in."
    else
      flash[:danger] = "Please try again."
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:danger] = "You've logged out."
    redirect_to root_path
  end
end