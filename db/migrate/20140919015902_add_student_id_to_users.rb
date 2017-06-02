class AddStudentIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :student_ID, :string
  end
end
