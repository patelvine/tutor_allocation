module Admin
  class Configuration < ActiveRecord::Base
    validates_presence_of :key, :value
    validate :check_deadline_is_date
    validate :check_year_and_term
    validate :check_tutor_hours
    validate :check_course_multipliers

    def self.deadline
      Date.parse(where(key: "deadline").first.try(:value) || '1970-01-01')
    end

    def self.deadline=(val)
      date = find_or_initialize_by(key: "deadline")
      date.value = val.is_a?(Date) ? val.to_s : val
      date.save
    end

    def self.tutor_hours
      where(key: "tutor_hours").first.try(:value).try(:to_i) || 70
    end

    def self.set_tutor_hours(val)
      field = find_or_initialize_by(key: "tutor_hours")
      field.value = val
      field.save
    end

    def self.course_hours(level)
      where(key: "course_hours_#{level}_level").first.try(:value).to_i || 4
    end

    def self.set_course_hours(level, val)
      field = find_or_initialize_by(key: "course_hours_#{level}_level")
      field.value = val
      field.save
    end

    def self.year
      (where(key: "year").first.try(:value) || 1970).to_i
    end

    def self.set_year(val)
      year = find_or_initialize_by(key: "year")
      year.value = val ? val.to_s : val
      year.save
    end

    def self.term
      (where(key: "term").first.try(:value) || 1).to_i
    end

    def self.set_term(val)
      term = find_or_initialize_by(key: "term")
      term.value = val ? val.to_s : val
      term.save
    end

    private

    def check_deadline_is_date
      if key == "deadline"
        begin
          Date.parse(value)
        rescue
          errors.add(:base, "Date is invalid")
        end
      end
    end

    def check_year_and_term
      if key == "year"
        if !is_num?(value)
          errors.add(:base, "Year is invalid")
        end
      end
      if key == "term"
        if !is_num?(value)
          errors.add(:base, "Term is invalid")
        else
          errors.add(:base, "Term is invalid") if ![1,2,3].include? value.to_i
        end
      end
    end

    def check_tutor_hours
      if key == "tutor_hours"
        if !is_num?(value)
          errors.add(:base, "not numeric")
        end
      end
    end

    def check_course_multipliers
      required = ["course_hours_100_level", "course_hours_200_level", "course_hours_300_level", "course_hours_400_level"]
      if required.include? key
        if !is_num?(value)
          errors.add(:base, "not numeric")
        end
      end
    end

    def is_num?(str)
      begin
        !!Integer(str)
      rescue ArgumentError, TypeError
        false
      end
    end

  end
end
