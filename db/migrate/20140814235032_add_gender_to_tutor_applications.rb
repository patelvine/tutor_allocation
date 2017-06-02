class AddGenderToTutorApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :tutor_applications, :gender, :string
  end
end
