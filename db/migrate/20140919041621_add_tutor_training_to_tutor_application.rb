class AddTutorTrainingToTutorApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :tutor_applications, :tutor_training, :string
  end
end
