class Admin::HourlyRates < ActiveRecord::Base
  validates_inclusion_of :level, :in => ["200 level", "300 level", "Graduate", "Hons Graduate", "MSc"]
  validates_inclusion_of :years_experience, :in => [0,1,2,3]

  def self.levels
    ["200 level", "300 level", "Graduate", "Hons Graduate", "MSc"]
  end

  def self.levels_form
    out = {}
    levels.each_with_index{|v, i| out[v] = i }
    out
  end

  def self.years_experience
    [0, 1, 2, 3]
  end
end
