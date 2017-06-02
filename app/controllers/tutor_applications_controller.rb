class TutorApplicationsController < ApplicationController

  include ActionView::Helpers::NumberHelper

  #before_action :authorize_tm, only: [:index, :tutor_list_xls, :application_print, :update_pay, :disqualify_tutor]
  #before_action :authorize_tm_or_cc, only: [:show, :update_comment]
  #before_action :authorize_tm_or_student, only: [:update, :edit, :create, :new]

  # anyone logged in
  def new
    if Date.today > Admin::Configuration.deadline
      render :deadline_passed and return
    end
    @application = TutorApplication.where(student_ID: current_user.student_ID)
    if @application.any?
      redirect_to edit_tutor_application_path(@application.first)
    end
    @tutor_application = TutorApplication.new
  end

  # anyone logged in
  def create
    render :deadline_passed and return if before_deadline?

    @tutor_application = TutorApplication.new(tutor_application_params)
    if @tutor_application.save
      if current_user.TM?
        redirect_to tutor_applications_path, :notice => 'Application created'
      else
        redirect_to edit_tutor_application_path(@tutor_application), :notice => 'Application created'
      end
     else
      render :new
    end
  end

  #TM only
  def index
    if params[:filters]
      @tutor_applications = TutorApplication.current_applications
      @tutor_applications = @tutor_applications.select do |application|
        keep = false
        @filters = params[:filters].split(" ")
        @filters.each do |filter|
          keep = true if application.tags.any?{|tagarray| tagarray[0].match(filter)}
        end
        keep
      end
    else
      @tutor_applications = TutorApplication.current_applications
    end
  end

  #TM and CC and student
  def show
    @tutor_application = TutorApplication.find(params[:id])
    @courses = Course.all.sort_by{|c| @tutor_application.suitability_for_course(c)}.reverse
    @allocation_links = @tutor_application.allocation_links
    if current_user.CC? && !@allocation_links.any? { |al| al.course.course_coordinator_id == current_user.id }
      redirect_to login_path, :notice => 'You are not authorised.' and return
    end
    find_grades
    if @tutor_application.allocation_links.allocated.size > 2
      flash.now[:error] = "Tutor is allocated to more than 2 courses."
    end
  end

  def application_print
    @tutor_application = TutorApplication.find(params[:id])
    find_grades
    render layout: false
  end

  # TM and student
  def edit
    @tutor_application = TutorApplication.find(params[:id])
    if current_user.student? && @tutor_application.student_ID != current_user.student_ID
      redirect_to root_path
    end
  end

  # TM and student
  def update
    render :deadline_passed, status: 423 and return if before_deadline?
    @tutor_application = TutorApplication.find(params[:id])
    if @tutor_application.update(tutor_application_update_params)
      if current_user.TM?
        redirect_to tutor_application_path(@tutor_application), :notice => 'Application updated'
      else
        redirect_to edit_tutor_application_path(@tutor_application), :notice => 'Application updated'
      end

    else
      render :edit, :notice => 'Application update failed'
    end
  end

  def update_pay
    render :deadline_passed, status: 423  and return if before_deadline?
    @tutor_application = TutorApplication.find(params[:id])
    update = {years_experience: tutor_application_update_params[:years_experience], pay_level: tutor_application_update_params[:pay_level]}
    if @tutor_application.update(update)
      render json: { pay_rate: number_to_currency(@tutor_application.reload.pay_rate), scholarship: !!@tutor_application.vuw_doctoral_scholarship? }
    else
      head 400
    end
  end

  #TM and CC
  def update_comment
    @tutor_application = TutorApplication.find(params[:id])
    if @tutor_application.update(comment_param)
      redirect_to tutor_application_path(@tutor_application), :notice => 'Comment updated'
    else
      render :show, :notice => 'Comment update failed'
    end
  end

  def disqualify_tutor
    @tutor_application = TutorApplication.find(params[:id])
    @tutor_application.disqualify
    redirect_to tutor_application_path(@tutor_application), :notice => 'Application Disqualifed'
  end

  #TM only
  def export_all_tutors
    @tutor_applications = TutorApplication.current_applications


    #symbols = @tutor_applications.column_names.map(&:to_sym).reject{|k| k.to_sym == :id}
    symbols = [:first_name, :last_name, :gender, :student_ID, :ecs_email, :private_email, :mobile_number,
      :home_phone, :preferred_hours, :enrolment_level, :qualifications, :first_choice, :second_choice, :previous_non_tutor_vuw_contract,
      :previous_tutor_experience, :other_information, :vuw_doctoral_scholarship, :teaching_qualification,
      :comment, :year, :term, :tutor_training, :years_experience, :created_at, :updated_at]
    keys = []

    tutors = []
    symbols.each do |sym|
      keys.push TutorApplication.field_to_name(sym)
    end

    @tutor_applications.each do |application|
      tutors.push(application.to_xls)
    end

    tempfile = Tempfile.new("test.xls")
    book = ExcelExport.export_tutor_list({keys: keys, tutors: tutors})
    book.write(tempfile.path)
    send_file tempfile.path, filename: "test.xls"
  end

  def export_finalised_tutors
    filename = 'test_finalised.xls'
    tempfile = Tempfile.new(filename)
    book = ExcelExport.export_finalised_tutors AllocationLink.allocated
    book.write tempfile.path
    send_file tempfile.path, filename: filename
  end

  private

  def comment_param
    params.require(:tutor_application).permit(:comment)
  end

  def tutor_application_params
    params.require(:tutor_application).permit(:first_name, :last_name, :student_ID, :ecs_email,
      :private_email, :mobile_number, :home_phone, :preferred_hours, :enrolment_level,
      :qualifications, :first_choice_id, :second_choice_id, :previous_non_tutor_vuw_contract,
      :previous_tutor_experience, :other_information, :vuw_doctoral_scholarship, :gender, :photo, :transcript,
      :tutor_training, :teaching_qualification)
  end

  def tutor_application_update_params
    params.require(:tutor_application).permit(:first_name, :last_name,
      :private_email, :mobile_number, :home_phone, :preferred_hours, :enrolment_level,
      :qualifications, :first_choice_id, :second_choice_id, :previous_non_tutor_vuw_contract,
      :previous_tutor_experience, :other_information, :vuw_doctoral_scholarship, :gender, :photo, :transcript,
      :tutor_training, :pay_level, :years_experience, :teaching_qualification)
  end

  def grades_to_array_with_suitability(tutor_application, grades)
    grades = tutor_application.get_grades
    out_grades = []
    grades.each do |k,v|
      out_grades << OpenStruct.new(course_code: k, grade: v, suitability: Suitability.suitability_rating(@tutor_application.suitability_for_course(Course.where(course_code: k).first)))
    end
    out_grades
  end

  def find_grades
    Suitability.where(tutor_application_id: @tutor_application.id).each{|s| s.delete}
    @tutor_application.calculate_suitability

    @grades = grades_to_array_with_suitability(@tutor_application, @tutor_application.get_grades())
  end

  def before_deadline?
    Date.today > Admin::Configuration.deadline
  end
end
