class AddEnrollmentNumberToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :enrollment_number, :integer, null: false, :default => 0
  end
end
