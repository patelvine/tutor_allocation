class UsersController < ApplicationController
  #skip_before_filter :authorize_login

  #before_filter :authorize_tm, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_path unless @user.CC?
    @courses = Course.where(course_coordinator_id: @user)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, :role, :student_ID)
   end
end
