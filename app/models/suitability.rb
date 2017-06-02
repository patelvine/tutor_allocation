class Suitability < ActiveRecord::Base
  def self.suitability_rating (s)
    if s >= 7
      5 #Excellent
    elsif s >= 5
      4 #Good
    elsif s >= 3
      3 #OK
    elsif s > 0
      2 #Bad
    else
      1 #Unsuitable
    end
  end

  def self.suitability_name (s)
    {
      5 => "Excellent",
      4 => "Good",
      3 => "OK",
      2 => "Poor",
      1 => "Unsuitable"
    }[s]
  end

  def self.suitability_label_name (s)
    {
      5 => "success",
      4 => "primary",
      3 => "info",
      2 => "warning",
      1 => "danger"
    }[s]
  end
end
