class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :alert_string

  #before_action :authorize_login, except: [:home_page]

  def home_page
    if !current_user
      redirect_to login_path
    elsif current_user.TM?
      redirect_to tutor_applications_path
    elsif current_user.CC?
      redirect_to courses_path
    elsif current_user.student?
      @application = TutorApplication.where(student_ID: current_user.student_ID)
      if @application.any?
        redirect_to edit_tutor_application_path(@application.first)
      else
        redirect_to new_tutor_application_path
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def alert_string (string)
    {
      "notice" => "info",
      "error" => "danger"
    }[string] || ""
  end

  def authorize_login
    redirect_to login_path, notice: "You are not authorized to view this page" if current_user.nil?
  end

  def authorize_cc
    redirect_to login_path, notice: "You are not authorized to view this page" unless current_user.present? && current_user.CC?
  end

  def authorize_tm
    redirect_to login_path, notice: "You are not authorized to view this page" unless current_user.present? && current_user.TM?
  end

  def authorize_tm_or_cc
    redirect_to login_path, notice: "You are not authorized to view this page" unless current_user.present? && (current_user.TM? || current_user.CC?)
  end

  def authorize_student
    redirect_to login_path, notice: "You are not authorized to view this page" unless current_user.present? && current_user.student?
  end

  def authorize_tm_or_student
    redirect_to login_path, notice: "You are not authorized to view this page" unless current_user.present? && (current_user.TM? || current_user.student?)
  end
end
