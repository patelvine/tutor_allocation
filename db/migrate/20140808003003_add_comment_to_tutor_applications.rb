class AddCommentToTutorApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :tutor_applications, :comment, :text
  end
end
