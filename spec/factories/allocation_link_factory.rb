FactoryGirl.define do
  factory :allocation_link do
    association :tutor_application, factory: :tutor_application
    association :course, factory: :course
    state :awaiting
  end

end
