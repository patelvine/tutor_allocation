FactoryGirl.define do
  factory :admin_hourly_rate, class: Admin::HourlyRates do
    level { Admin::HourlyRates.levels[(Random.rand*5).to_i] }
    years_experience { Admin::HourlyRates.years_experience[(Random.rand*4).to_i] }
    rate { Faker::Number.number(4) }
  end
end
