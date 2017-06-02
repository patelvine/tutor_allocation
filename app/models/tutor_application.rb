class TutorApplication < ActiveRecord::Base
  include TutorApplicationHelper

  has_many :suitabilities
  has_many :allocation_links
  has_many :courses, through: :allocation_links

  validates_presence_of :first_name, :last_name, :student_ID, :ecs_email,
                        :private_email, :mobile_number, :preferred_hours,
                        :first_choice, :second_choice

  validates_uniqueness_of :student_ID
  validates :years_experience, numericality: { greater_than_or_equal_to: 0, less_than: 4 }
  validates :pay_level, numericality: { greater_than_or_equal_to: 0, less_than: 5 }

  validates :preferred_hours, numericality: { greater_than: 0, less_than: 100 }

  validate :email

  validate :enrolment_level_valid
  validate :qualifications_valid
  validate :tutor_training_valid

  validate :course_valid

  belongs_to :first_choice, class_name: "Course"
  belongs_to :second_choice, class_name: "Course"

  after_create :calculate_suitability
  after_create :add_year_and_term
  after_create :make_allocations
  has_attached_file :photo, {
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :default_url => "/assets/user.png",
    :hash_secret => Rails.application.secrets[:secret_key_base],
    :url => "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
    :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:hash.:extension"
  }
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :transcript, {
    :hash_secret => Rails.application.secrets[:secret_key_base],
    :url => "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
    :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:hash.:extension"
  }
  validates_attachment_content_type :transcript, :content_type => ['application/pdf']

  before_save :set_term_year

  scope :current_applications, -> { where(year: Admin::Configuration.year, term: Admin::Configuration.term)}

  def set_term_year
    term = Admin::Configuration.term
    year = Admin::Configuration.year
  end  

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.qualifications
    ["", "Bachelors", "Masters", "PhD", "Diploma"]
  end

  def self.enrolment_level
    ["", "2nd Year", "3rd Year", "4th Year/Honours", "Masters", "PhD"]
  end

  def self.genders
    ["Male", "Female", "Other"]
  end

  def self.tutor_training
    ["","ECS", "CAD"]
  end

  def self.field_to_name(field)
    fields = {
      :first_name => "First Name",
      :last_name => "Last Name",
      :gender => "Gender",
      :student_ID => "Student ID",
      :ecs_email => "ECS Email",
      :private_email => "Private Email",
      :mobile_number => "Mobile Number",
      :home_phone => "NZ Phone Number",
      :preferred_hours => "Preferred Hours per Week",
      :enrolment_level => "Enrolment When Trimester Starts",
      :qualifications => "Qualifications/Degrees Completed",
      :first_choice => "First Choice Course to Tutor",
      :second_choice => "Second Choice Course to Tutor",
      :previous_non_tutor_vuw_contract => "Previous Non-Tutor Contract With VUW",
      :previous_tutor_experience => "Previous Tutor Experience",
      :other_information => "Other Information",
      :vuw_doctoral_scholarship => "VUW Doctoral Scholarship?",
      :teaching_qualification => "Teaching Qualification?",
      :comment => "Comments",
      :year => "Year",
      :term => "Term",
      :tutor_training => "Tutor Training",
      :years_experience => "Years Experience",
      :created_at => "Created At",
      :updated_at => "Updated At"
    }

    fields[field]
  end

  def allocated? (course)
    if course.is_a? Integer
      return !AllocationLink.where(course_id: course, tutor_application_id: self.id).first.nil?
    else
      return !AllocationLink.where(course_id: course.id, tutor_application_id: self.id).first.nil?
    end
  end

  def disqualify
    allocation_links.each do |allocation|
      allocation.update(state: :rejected)
    end
  end

  def to_xls
    xls = attributes.reject{|k,v| [:id, :suitability].include? k.to_sym || k.to_s =~ /photo/ || k.to_s =~ /transcript/}
    xls["first_choice"] = first_choice_name
    xls["second_choice"] = second_choice_name
    xls["vuw_doctoral_scholarship"] = vuw_doctoral_scholarship ? "Yes" : "No"
    xls["teaching_qualification"] = teaching_qualification ? "Yes" : "No"
    xls
  end

  def first_choice_name
    first_choice.course_code
  end

  def second_choice_name
    second_choice.course_code
  end

  def grade_for_course(course)
    grade = get_grades()[course.course_code]
    grade ||= "No grade available"
  end

  def suitability_name_for_course(course)
    s = suitability_for_course(course)
    Suitability.suitability_name(Suitability.suitability_rating(s))
  end

  def suitability_label_name_for_course(course)
    s = suitability_for_course(course)
    Suitability.suitability_label_name(Suitability.suitability_rating(s))
  end

  def suitability_for_course(course)
    return 0 unless course.is_a? Course
    s = Suitability.where(tutor_application_id: id, course_id: course.id).first
    if s.present?
      return s.suitability
    else
      return 0
    end
  end

  def calculate_suitability
    grades = get_grades()

    Course.all.each do |course|
      value = 0.0
      if previous_tutor_experience.present?
        value += 3
      elsif previous_non_tutor_vuw_contract.present?
        value += 1
      end

      if grades[course.course_code].present?
        val = value_of_grade(grades[course.course_code])
        if val >= 7 #Grade A- or above
          value += 3
        elsif val >= 6
          value += 1
        else
          value -= 3
        end
      else #Haven't done the paper
        value -= 1000
      end

      if average_grade > 7
        value += 2
      elsif average_grade > 5
        value += 1
      else
        value -= 2
      end
      if teaching_qualification
        value += 2
      end
      if gender == "Female"
        value += 1
      end

      record = Suitability.where(tutor_application_id: id, course_id: course.id).first
      if record.present?
        record.update_column(:suitability, value)
      else
        Suitability.create(tutor_application_id: id, course_id: course.id, suitability: value)
      end
    end
  end

  def average_grade
    grades = get_grades()
    size = grades.size
    (grades.values.map {|grade| value_of_grade(grade).to_f}.reduce(:+) / size.to_f)
  end

  def suitability_string
    base_suitability = {}

    if previous_tutor_experience.present?
      base_suitability["previous tutor experience"] = 3
    elsif previous_non_tutor_vuw_contract.present?
      base_suitability["previous non tutor vuw contract"] = 1
    end
    if average_grade > 7
      base_suitability["average grade"] = 2
    elsif average_grade > 5
      base_suitability["average grade"] = 1
    else
      base_suitability["average grade"] = -2
    end
    if teaching_qualification
      base_suitability["teaching qualification"] = 2
    end
    if gender == "Female"
      base_suitability["gender"] = 1
    end

    pretty_string = ""
    base_suitability.entries.each do |key, value|
      pretty_string << key + ": " + value.to_s + ", "
    end
    "Suitability is calculated with: " + pretty_string + "plus the value depending on their grade in the course"
  end

  def pay_rate
    return 0 if self.vuw_doctoral_scholarship?
    Admin::HourlyRates.where(level: Admin::HourlyRates.levels[self.pay_level],
                             years_experience: self.years_experience).first.try(:rate) || 0
  end

  def tags
    tags = []
    allocations = allocation_links
    allocated = 0
    proposed = 0
    rejected = 0
    accepted = 0
    reserved = 0
    shortlisted = 0
    unallocated = 0

    allocations.each do |a|
      rejected += 1 if a.rejected?
      proposed += 1 if a.awaiting?
      allocated += 1 if a.allocated?
      reserved += 1 if a.reserve?
      shortlisted += 1 if a.shortlisted?
      accepted += 1 if a.accepted?
      unallocated += 1 if a.unallocated?
    end


    if rejected == allocations.size
      tags << ["Disqualified", "danger"]
      rejected = 0
    end

    tags << ["Rejected (#{rejected})", "danger"] if rejected > 0
    tags << ["Planned (#{proposed})", "info"] if proposed > 0
    tags << ["Accepted (#{accepted})", "primary"] if accepted > 0
    tags << ["Allocated (#{allocated})", "success"] if allocated > 0
    tags << ["Reserved (#{reserved})", "default"] if reserved > 0
    tags << ["Shortlisted (#{shortlisted})", "warning"] if shortlisted > 0
    tags << ["Unallocated", "default"] if unallocated == allocations.size
    tags
  end

  def self.tags
    "Disqualified Unallocated Planned Reserve Shortlisted Accepted Rejected Allocated"
  end

  private

  def email
    #do we need to?
  end

  def enrolment_level_valid
    if !self.enrolment_level.in? TutorApplication.enrolment_level
      errors.add(:enrolment_level, "Not a valid enrolment level")
    end
  end

  def qualifications_valid
    if  !self.qualifications.in? TutorApplication.qualifications
      errors.add(:qualifications, "Not a valid qualification")
    end
  end

  def tutor_training_valid
    if  !self.tutor_training.in? TutorApplication.tutor_training
      errors.add(:tutor_training, "Not a valid tutor training")
    end
  end

  def course_valid
    if self.first_choice == self.second_choice
      errors.add(:second_choice, "Second choice cannot be the same as the first choice")
    end
  end

  def add_year_and_term
    self.year = Admin::Configuration.year
    self.term = Admin::Configuration.term
    self.save!
  end

  def make_allocations
    Course.all.each do |course|
      AllocationLink.create(tutor_application_id: self.id, course_id: course.id, state: :unallocated)
    end
  end

end
