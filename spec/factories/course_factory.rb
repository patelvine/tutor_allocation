FactoryGirl.define do
  factory :course do
    name              { Faker::Name.first_name }
    course_code       { Faker::Code.isbn(10) }
    tutors_required   100


  end

end
