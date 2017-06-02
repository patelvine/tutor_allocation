class AddYearAndTermToTutorApplication < ActiveRecord::Migration[5.0]
  def up
    add_column :tutor_applications, :year, :integer
    add_column :tutor_applications, :term, :integer
    TutorApplication.all.each do |ta|
      ta.year = Admin::Configuration.year
      ta.term = Admin::Configuration.term
      ta.save
    end
  end

  def down
    remove_column :tutor_applications, :year
    remove_column :tutor_applications, :term
  end
end
