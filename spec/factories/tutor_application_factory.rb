FactoryGirl.define do
  factory :tutor_application do
    first_name      { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    gender          "Female"
    student_ID      { Faker::Number.number(9) }
    ecs_email       { Faker::Internet.email }
    private_email   { Faker::Internet.email }
    mobile_number   { Faker::Number.number(10) }
    preferred_hours { 10 }
    enrolment_level ""
    qualifications  ""
    tutor_training  ""
    pay_level         1
    years_experience  1
    association :first_choice, factory: :course
    association :second_choice, factory: :course
  end

end
