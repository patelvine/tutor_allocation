class Course < ActiveRecord::Base

  has_many :allocation_links
  has_many :tutor_applications, through: :allocation_links

  validates_uniqueness_of :course_code

  enum state: %w(dormant awaiting_cc awaiting_tm finalised)

  def self.recalculate_all_tutors!
    self.all.each{|c| c.calculate_required_tutors!}
  end

  #Pretty print state name
  def pp_state
    self.class.pp_state state
  end

  def self.pp_state (state)
    {
      :dormant => "Awaiting allocations",
      :awaiting_cc => "Waiting for Course Coordinator",
      :awaiting_tm => "Waiting for Tutor Manager",
      :finalised => "Finalised"
    }[state.to_sym]
  end

  def pp_state_for_user(user)
    action = self.state.to_sym
    if [:awaiting_tm, :awaiting_cc].include? self.state.to_sym
      action = self.awaiting_cc? ? :awaiting_me : :awaiting_tm if user.CC?
      action = self.awaiting_tm? ? :awaiting_me : :awaiting_cc if user.TM?
    end
    return "Waiting for you" if action == :awaiting_me
    return Course.pp_state(action)
  end

  def subtotal_spent
    allocations = AllocationLink.where(course_id: id)
    if finalised?
      allocations = allocations.allocated
    elsif awaiting_tm?
      allocations = allocations.accepted
    elsif awaiting_cc?
      allocations = allocations.shortlisted
    else
      allocations = allocations.awaiting
    end

    total = 0
    allocations.each do |allocation|
      total+= (allocation.tutor_application.pay_rate * Admin::Configuration.tutor_hours)
    end

    total
  end

  def course_multiplier
    num = /\d/.match course_code
    Admin::Configuration.course_hours(num[0]*100)
  end

  def calculate_required_tutors
    calculate_required_tutors_with_enroll(enrollment_number)
  end

  def calculate_required_tutors_with_enroll(enroll_no)
    hours_per_tutor = Admin::Configuration.tutor_hours
    (enroll_no.to_i * course_multiplier) / hours_per_tutor
  end

  def calculate_required_tutors!
    self.update_column(:tutors_required, calculate_required_tutors)
  end

  def self.field_to_name(field)
    fields = {
      :name => "Name",
      :course_code => "Course Code",
      :tutors_required => "Tutors Required",
      :id => "Course ID"
    }

    fields[field.to_sym]
  end

  def get_allocated_tutors
    AllocationLink.allocated.where(course: self)
  end

  def get_course_coordinator
    course_coordinator_id ? User.find(course_coordinator_id) : nil
  end

  def to_xls
    data = {}
    data[:name] = name
    data[:course_code] = course_code
    data[:tutors_required] = tutors_required
    data[:id] = id

    @allocations = AllocationLink.allocated.where(course_id: self.id)


    course_symbols = [:name, :course_code, :tutors_required, :id]
    course_keys = []


    course_symbols.each do |sym|
      course_keys.push Course.field_to_name(sym)
    end

    tutors = []

    applicaton_symbols = [:first_name, :last_name, :student_ID, :first_choice, :second_choice, :pay_rate]
    application_keys = []

    applicaton_symbols.each do |sym|
      application_keys.push TutorApplication.field_to_name(sym)
    end

    @allocations.each do |allocation|
      tutors.push(TutorApplication.find(allocation.tutor_application_id).to_xls)
    end

    return {course: {course_keys: course_keys, course: data}, allocations: {application_keys: application_keys, tutors: tutors}}


  end

  def awaiting_colour(user)
    colours = {
      :dormant => "active",
      :awaiting_me => "info",
      :awaiting_them => "warning",
      :finalised => "success"
    }
    action = self.state.to_sym
    if [:awaiting_tm, :awaiting_cc].include? self.state.to_sym
      action = self.awaiting_cc? ? :awaiting_me : :awaiting_them if user.CC?
      action = self.awaiting_tm? ? :awaiting_me : :awaiting_them if user.TM?
    end

    colours[action]
  end

  def has_accepted?
    allocation_links.accepted.any?
  end

  def course_applications
    als = AllocationLink.where(course_id: self.id)
    als.reject{|al| al.unallocated? || al.awaiting?}.map(&:tutor_application)
  end
end
