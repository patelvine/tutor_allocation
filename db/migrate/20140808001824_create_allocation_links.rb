class CreateAllocationLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :allocation_links do |t|
      t.integer :tutor_application_id
      t.integer :course_id
      t.integer :state

      t.timestamps
    end
  end
end
