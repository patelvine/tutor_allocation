class CreateSuitabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :suitabilities do |t|
      t.integer :tutor_application_id
      t.integer :course_id
      t.float :suitability

      t.timestamps
    end
  end
end
