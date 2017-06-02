class CoursesController < ApplicationController


  #before_action :authorize_tm, only: [:update, :calculate_required_tutors, :export_course, :finalise_accepted]
  #before_action :authorize_tm_or_cc, only: [:index, :show, :propose_course]

  # CC and TM
  def index
    if current_user.TM?
      @courses = Course.all
    elsif current_user.CC?
      @courses = Course.where(course_coordinator_id: current_user.id)
    end
  end

  # CC and TM
  def show
    #Change view such that fields do not appear to be editible.
    @course = Course.find(params[:id])
    if !current_user.TM? && @course.course_coordinator_id != current_user.id
      redirect_to login_path, notice: "You are not authorized to view this page"
    end
    setup_course_show @course.id
  end

  # TM
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      redirect_to course_path, :notice => "Successfully saved"
    else
      flash.now[:error] = "Not saved"
      render :show
    end
  end

  # TM
  def calculate_required_tutors
    @course = Course.find(params[:id])
    setup_course_show @course.id
    if @course.update(:tutors_required => @course.calculate_required_tutors)
      flash.now[:notice] = "Calculated required tutors"
      render :show
    else
      flash.now[:notice] = "Error calculating tutors"
      render :show
    end
  end

  def get_no_required_tutors
    @course = Course.where(id: params[:id]).first
    if @course && params[:enrol]
      render json: { value: @course.calculate_required_tutors_with_enroll(params[:enrol]) }
    else
      head status: 400
    end
  end

  # TM OR CC
  def propose_course
    if current_user.TM? #Update course state, and allocation states
      @course = Course.find(params[:id])
      @course.awaiting_cc!

      setup_course_show @course.id

      allocations = AllocationLink.awaiting.where(course_id: @course.id)
      allocations.each do |a|
        a.shortlisted!
      end

      redirect_to course_path(@course.id), flash: { notice: "Proposed Course" }
    elsif current_user.CC? #Update course state
      @course = Course.where(id: params[:id]).first
      if @course && @course.awaiting_cc? && current_user.id == @course.course_coordinator_id
        @course.awaiting_tm!
        redirect_to course_path(@course.id), flash: { notice: "Updated  course" }
      else
        redirect_to courses_path, flash: { error: "There was an error updating the specified course." }
      end
    end
  end

  # TM
  def finalise_accepted
    @course = Course.find(params[:id])
    if !@course.has_accepted?
      redirect_to course_path(@course), flash: { error: "There are no accepted tutors to finalise" }
      return
    end
    setup_course_show @course.id

    @allocations.accepted.each do |allocation|
      allocation.update(state: :allocated)
    end

    if @overallocated.empty?
      redirect_to course_path(@course), flash: { notice: "Moved accepted tutors to allocated state." }
    else
      redirect_to course_path(@course), flash: { notice: "Moved accepted tutors to allocated state. WARNING there are some people in this course tutoring more than 2 courses." }
    end
  end

  def export_all_courses
    courses = Course.all

    tempfile = Tempfile.new("test_all.xls")
    book = ExcelExport.export_all_courses courses
    book.write(tempfile.path)
    send_file tempfile.path, filename: "test_all.xls"
  end

  def export_course
    @course = Course.find(params[:id])

    tempfile = Tempfile.new("test.xls")
    book = ExcelExport.export_single_course(@course)
    book.write(tempfile.path)
    send_file tempfile.path, filename: "test.xls"
  end

  private

  def course_params
    params.require(:course).permit(:enrollment_number, :tutors_required, :state)
  end

  def setup_course_show(id)
    if current_user.TM?
      @allocations = AllocationLink.where(course_id: id)
    elsif current_user.CC?
      @allocations = AllocationLink.where(course_id: id, state: AllocationLink.cc_viewable_states)
    end

    allocations = AllocationLink.allocated.where(course_id: id)
    @overallocated = []
    allocations.each do |allocation|
      allocated_links = allocation.tutor_application.allocation_links.allocated
      @overallocated << allocation if allocated_links.size > 2
    end
  end
end
