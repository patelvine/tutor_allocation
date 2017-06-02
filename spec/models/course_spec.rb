require 'rails_helper'

describe Course do
	 let (:course) { create(:course) }
	 let!(:application_1) { create(:tutor_application) }
	 let (:allocation_1) { create(:allocation_link, course: course, tutor_application: application_1) }

	 context "exporting an course" do
	 	it "pulls all the required data" do
	 		allocation_1.update(state: "allocated")
	 		application_1
		 	data = course

                  xls_result = data.to_xls

                  course_data = xls_result[:course][:course]
                  application_data = xls_result[:allocations][:tutors][0]

                  expect(course_data[:name]).to eql course.name
                  expect(course_data[:course_code]).to eql course.course_code
                  expect(course_data[:tutors_required]).to eql course.tutors_required
                  expect(application_data["first_name"]).to eql application_1.first_name
                  expect(application_data["last_name"]).to eql application_1.last_name
                  expect(application_data["student_ID"]).to eql application_1.student_ID

                  firstChoice = Course.find(application_1.first_choice)
                  secondChoice = Course.find(application_1.second_choice)

                  expect(application_data["first_choice"]).to eql firstChoice.course_code
                  expect(application_data["second_choice"]).to eql secondChoice.course_code
            end
	end
end