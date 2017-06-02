require_relative '../../app/models/user'
FactoryGirl.define do
  factory :user, class: User do
    username { Faker::Name.first_name + "123"}
    email  { Faker::Internet.email }
    password "testpassword"
    password_confirmation "testpassword"
    role "CC"
    factory :user_tm do
      role "TM"
    end
    factory :user_student do
      role "student"
      student_ID { Faker::Number.number(9) }
    end
  end
end
