class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :tutor_applications do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :student_ID, null: false
      t.string :ecs_email, null: false
      t.string :private_email, null: false
      t.string :mobile_number, null: false
      t.string :home_phone
      t.integer :preferred_hours
      t.string :enrolment_level
      t.string :qualifications
      t.string :first_choice, null: false
      t.string :second_choice, null: false
      t.text :previous_non_tutor_vuw_contract
      t.text :previous_tutor_experience
      t.text :other_information
      t.boolean :vuw_scholarship

      t.timestamps
    end
  end
end
