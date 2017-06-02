class Admin::HourlyRatesConfiguration < ActiveRecord::Base
  validates_inclusion_of :level, :in => ["200 level", "300 level", "Graduate", "Hons Graduate", "MSc"]
  validates_inclusion_of :years_experience, :in => [0, 1, 2, 3]
end
