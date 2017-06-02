class ChangeFirstChoiceAndSecondChoiceToCourses < ActiveRecord::Migration[5.0]
  def change
    remove_column :tutor_applications, :first_choice
    remove_column :tutor_applications, :second_choice
    add_column    :tutor_applications, :first_choice_id, :integer
    add_column    :tutor_applications, :second_choice_id, :integer
  end
end
