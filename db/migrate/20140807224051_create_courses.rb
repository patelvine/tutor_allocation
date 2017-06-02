class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :course_code
      t.integer :tutors_required
      t.integer :state

      t.timestamps
    end
  end
end
