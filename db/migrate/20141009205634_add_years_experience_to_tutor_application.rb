class AddYearsExperienceToTutorApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :tutor_applications, :years_experience, :integer, null: false, default: 0
    add_column :tutor_applications, :pay_level, :integer, null: false, default: 0
  end
end
