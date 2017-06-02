class SessionsController < ApplicationController
  #skip_before_action :authorize_login

  def new
  end

  def create
    unless params[:session] && params[:session][:identifier] && params[:session][:password]
      flash.now.notice = "Invalid email or password"
      render :new and return
    end
    user = User.authenticate(params[:session][:identifier], params[:session][:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.notice = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
