class AddTeachingQualificationToTutorApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :tutor_applications, :teaching_qualification, :boolean
  end
end
