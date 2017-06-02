module TutorApplicationHelper
  #temporary stuff
  def get_grades()

    # courses = ["SWEN300", "SWEN301", "SWEN302", "SWEN303", "ENGL301", "COMP103", "COMP102", "SWEN222"]
    # numcourses = Course.count

    courses = []
    grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "E", "WD", "K"]

    constant_random = Random.new(student_ID.hash)
    Course.all.each do |course|
      courses << course.course_code
    end

    temporary_number = constant_random.rand(grades.count)

    persons_grades = {}

    courses.each do |course|
      random_number = constant_random.rand(5) - 5
      b = temporary_number + random_number
      b = 12 if b > 12
      b = 0 if b < 0

      persons_grades[course] = grades[b]

    end

    return persons_grades
  end

  def value_of_grade(gradestring)
    {
      "A+"  => 9,
      "A"   => 8,
      "A-"  => 7,
      "B+"  => 6,
      "B"   => 5,
      "B-"  => 4,
      "C+"  => 3,
      "C"   => 2,
      "C-"  => 1
    }[gradestring] || 0
  end
end
