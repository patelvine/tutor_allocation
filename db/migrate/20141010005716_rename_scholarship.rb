class RenameScholarship < ActiveRecord::Migration[5.0]
  def change
    rename_column(:tutor_applications, :vuw_scholarship, :vuw_doctoral_scholarship)
  end
end
