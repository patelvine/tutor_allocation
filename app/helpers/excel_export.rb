require 'spreadsheet'

class ExcelExport

  Spreadsheet.client_encoding = 'UTF-8'

  def self.export_tutor_list(tutor_attributes)
    book = Spreadsheet::Workbook.new
    tutor_list = book.create_worksheet :name => 'Tutor List'
    tutor_list.row(0).concat tutor_attributes[:keys]
    tutor_attributes[:tutors].each_with_index do |attributes, i|
      row = []

      symbols = [:first_name, :last_name, :gender, :student_ID, :ecs_email, :private_email, :mobile_number,
      :home_phone, :preferred_hours, :enrolment_level, :qualifications, :first_choice, :second_choice, :previous_non_tutor_vuw_contract,
      :previous_tutor_experience, :other_information, :vuw_doctoral_scholarship, :teaching_qualification,
      :comment, :year, :term, :tutor_training, :years_experience, :created_at, :updated_at]

      symbols.each do |symbol|
        row.push attributes[symbol.to_s]
      end
      tutor_list.row(i+1).concat row
    end

     #Format the purplish cells
    format = Spreadsheet::Format.new :pattern => 1, :pattern_fg_color => :xls_color_36, :left => :thin, :right => :thin, :top => :thin, :bottom => :thin
    (0...tutor_list.first.length).each do |i|
      tutor_list.row(0).set_format(i, format)
    end

    return book
  end

  def self.export_finalised_tutors(allocations)
    list = []
    allocations.each do |allocation|
      hash = {}
      tutor_application = allocation.tutor_application
      hash[:first_name] = tutor_application.first_name
      hash[:last_name] = tutor_application.last_name
      hash[:student_ID] = tutor_application.student_ID
      hash[:pay_rate] = tutor_application.pay_rate
      hash[:no_hours] = 70
      hash[:total_pay] = hash[:pay_rate] * hash[:no_hours]
      hash[:course] = allocation.course.course_code
      cc = allocation.course.course_coordinator_id ? User.find(allocation.course.course_coordinator_id).full_name : nil
      hash[:CC] = cc
      hash[:ecs_email] = tutor_application.ecs_email
      hash[:private_email] = tutor_application.private_email
      hash[:mobile] = tutor_application.mobile_number

      list << hash
    end

    list.sort! { |a, b| a[:student_ID] <=> b[:student_ID] }

    book = Spreadsheet::Workbook.new
    tutor_list = book.create_worksheet :name => 'Finalised Tutors'
    tutor_list[0,0] = "Student ID"
    tutor_list[0,1] = "First Name"
    tutor_list[0,2] = "Last Name"
    tutor_list[0,3] = "Course"
    tutor_list[0,4] = "Course Co-ordinator"
    tutor_list[0,5] = "Hourly Rate"
    tutor_list[0,6] = "Total Hours"
    tutor_list[0,7] = "Total Excl AL"
    tutor_list[0,8] = "ECS Email"
    tutor_list[0,9] = "Private Email"
    tutor_list[0,10] = "Mobile Number"

    list.each_with_index do |details, i|
      tutor_list[i+1,0] = details[:student_ID]
      tutor_list[i+1,1] = details[:first_name]
      tutor_list[i+1,2] = details[:last_name]
      tutor_list[i+1,3] = details[:course]
      tutor_list[i+1,4] = details[:CC]
      tutor_list[i+1,5] = details[:pay_rate]
      tutor_list[i+1,6] = details[:no_hours]
      tutor_list[i+1,7] = details[:total_pay]
      tutor_list[i+1,8] = details[:ecs_email]
      tutor_list[i+1,9] = details[:private_email]
      tutor_list[i+1,10] = details[:mobile]
    end

    #Format the purplish cells
    format = Spreadsheet::Format.new :pattern => 1, :pattern_fg_color => :xls_color_36, :left => :thin, :right => :thin, :top => :thin, :bottom => :thin
    (0...tutor_list.first.length).each do |i|
      tutor_list.row(0).set_format(i, format)
    end

    book
  end

  def self.export_all_courses(courses)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Courses'
    courses.each_with_index do |course, i|
      course_section course, i*7, 0, sheet
    end
    return book
  end

  def self.export_single_course(course)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Course'
    course_section course, 0, 0, sheet
    return book
  end

  def self.course_section(course, x, y, sheet)
    data = course.to_xls
    course_attributes = data[:course]
    tutor_attributes = data[:allocations]



    sheet[x,y] = course_attributes[:course][:course_code]
    sheet[x,y+1] = "hrs/stu"
    sheet[x,y+2] = "Tutor"
    cc = course.course_coordinator_id ? User.find(course.course_coordinator_id).full_name : "Missing"
    sheet[x+1,y] = cc
    sheet[x+1,y+1] = 4 #Need to figure out a way to get number of hours per student
    sheet[x+1,y+2] = "Hours"

    sheet[x+2,y] = "No of students"
    number = course.enrollment_number
    sheet[x+2,y+1] = number
    sheet[x+2,y+2] = "Tasks"

    sheet[x+3,y] = "SLP hours"
    sheet[x+3,y+1] = sheet[x+1,y+1] * sheet[x+2,y+1]
    sheet[x+3,y+2] = "Hourly Rate"

    sheet[x+4,y] = "No. required"
    sheet[x+4,y+2] = "Cost($)"


    tutor_attributes[:tutors].each_with_index do |attributes, i|
        sheet[x,y+i+3] = attributes[:first_name] + " " + attributes[:last_name]
        sheet[x+1,y+i+3] = Admin::Configuration.tutor_hours #Zarinah said something about 70 hours is the standard but her examples show otherwise. Need to confirm.
        #sheet[x+2, i+3] = "" This is for tasks. Need to talk to Zarinah to understand what this means
        sheet[x+3,y+i+3] = attributes[:pay_rate]
        sheet[x+4,y+i+3] = sheet[x+1,y+i+3]*sheet[x+3,y+i+3]
    end



    sheet[x, y+tutor_attributes[:tutors].count+3] = "SLP Hours"

    sumOfHours = 0
    (0..tutor_attributes[:tutors].count-1).each do |i|
      sumOfHours += sheet[x+1,y+i+3]
    end
    sheet[x+1, y+tutor_attributes[:tutors].count+3] = sumOfHours

    sumOfCost = 0
    (0..tutor_attributes[:tutors].count-1).each do |i|

      sumOfCost += sheet[x+4,y+i+3]
    end
    sheet[x+4, y+tutor_attributes[:tutors].count+3] = sumOfCost

    #debugger

    #Format the purplish cells
    bgColBlue = Spreadsheet::Format.new :pattern => 1, :pattern_fg_color => :xls_color_36, :left => :thin, :right => :thin, :top => :thin, :bottom => :thin
    (0..(sheet.rows.length - x)).each do |i|
      (0..2).each do |j|
        sheet.row(x+i).set_format(y+j, bgColBlue)
      end
      sheet.row(x+i).set_format(y+tutor_attributes[:tutors].count+3, bgColBlue)
    end

    #Format the light cells
    bgColLight = Spreadsheet::Format.new :pattern => 1, :pattern_fg_color => :xls_color_18, :left => :thin, :right => :thin, :top => :thin, :bottom => :thin
    (0..(sheet.rows.length - x)).each do |i|
      (3..tutor_attributes[:tutors].count+2).each do |j|
        sheet.row(x+i).set_format(y+j, bgColLight)
      end
    end
  end
end