# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141010005716) do

  create_table "admin_configurations", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_hourly_rates", force: :cascade do |t|
    t.string "level"
    t.integer "years_experience"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allocation_links", force: :cascade do |t|
    t.integer "tutor_application_id"
    t.integer "course_id"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.integer "tutors_required"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enrollment_number", default: 0, null: false
    t.string "course_code"
    t.integer "course_coordinator_id"
    t.index ["course_coordinator_id"], name: "index_courses_on_course_coordinator_id"
  end

  create_table "suitabilities", force: :cascade do |t|
    t.integer "tutor_application_id"
    t.integer "course_id"
    t.float "suitability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutor_applications", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "student_ID", null: false
    t.string "ecs_email", null: false
    t.string "private_email", null: false
    t.string "mobile_number", null: false
    t.string "home_phone"
    t.integer "preferred_hours"
    t.string "enrolment_level"
    t.string "qualifications"
    t.text "previous_non_tutor_vuw_contract"
    t.text "previous_tutor_experience"
    t.text "other_information"
    t.boolean "vuw_doctoral_scholarship"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.integer "first_choice_id"
    t.integer "second_choice_id"
    t.string "gender"
    t.boolean "teaching_qualification"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "transcript_file_name"
    t.string "transcript_content_type"
    t.integer "transcript_file_size"
    t.datetime "transcript_updated_at"
    t.integer "year"
    t.integer "term"
    t.string "tutor_training"
    t.integer "years_experience", default: 0, null: false
    t.integer "pay_level", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_hash"
    t.string "password_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "student_ID"
  end

end
