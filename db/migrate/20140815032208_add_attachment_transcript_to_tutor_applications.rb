class AddAttachmentTranscriptToTutorApplications < ActiveRecord::Migration[5.0]
  def self.up
    change_table :tutor_applications do |t|
      t.attachment :transcript
    end
  end

  def self.down
    remove_attachment :tutor_applications, :transcript
  end
end
