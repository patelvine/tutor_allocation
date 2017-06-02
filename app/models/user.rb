class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_format_of :username, :with => /\A[a-zA-Z]+([a-zA-Z]|\d)*\Z/
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_length_of :username, :minimum => 3

  validate :valid_role
  validate :validate_student_ID

  def self.roles
    ["CC", "TM", "student"]
  end

  def self.authenticate(identifier, password)
      user = find_by_email(identifier)
      user ||= find_by_username(identifier)
      if user && user.password.to_s == password.to_s
        user
      else
        nil
      end
  end

  def full_name
    # TODO make this better after integrating with login systems
    email
  end

  def encrypt_password
    if password.present?
      #self.password_salt = BCrypt::Engine.generate_salt
      #self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def CC?
    self.role == "CC"
  end

  def TM?
    self.role == "TM"
  end

  def CC_or_TM?
    self.role == "CC" || self.role == "TM"
  end


  def student?
    self.role == "student"
  end

  private

  def valid_role
    unless self.class.roles.include? self.role
        errors.add(:role, "role is not valid")
        return false
    end
    return true
  end

  def validate_student_ID
    if student?
      if student_ID.nil?
        errors.add(:student_ID, "Don't add a student_ID id the role is not student")
        return
      end
      if User.find_by(student_ID: student_ID)
        errors.add(:student_ID, "Student_ID must be unique")
        return
      end
    else
      student_ID.present? ? errors.add(:student_ID, "If the user is a student then they need a student_ID") : return
    end
  end

end
