class AddCourseCoordinatorToCourses < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :course_coordinator, references: :users, index: true
  end
end
