# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_25_040526) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "applied_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "candidate_skills", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_candidate_skills_on_candidate_id"
    t.index ["skill_id"], name: "index_candidate_skills_on_skill_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "resume"
    t.date "date_of_birth"
    t.text "languages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "disabilities", force: :cascade do |t|
    t.string "disability_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.string "institution_name"
    t.string "degree"
    t.string "field_of_study"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_educations_on_candidate_id"
  end

  create_table "employers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "company_name"
    t.text "company_description"
    t.string "website"
    t.string "industry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_employers_on_user_id"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "registered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
    t.index ["user_id"], name: "index_event_registrations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "employer_id", null: false
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_events_on_employer_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.string "job_title"
    t.string "company_name"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_experiences_on_candidate_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "employer_id", null: false
    t.string "title"
    t.text "description"
    t.string "location"
    t.text "requirements"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_jobs_on_employer_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "skill_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_disabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "disability_id", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disability_id"], name: "index_user_disabilities_on_disability_id"
    t.index ["user_id"], name: "index_user_disabilities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "profile_picture"
    t.text "bio"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "jobs"
  add_foreign_key "applications", "users"
  add_foreign_key "candidate_skills", "candidates"
  add_foreign_key "candidate_skills", "skills"
  add_foreign_key "candidates", "users"
  add_foreign_key "educations", "candidates"
  add_foreign_key "employers", "users"
  add_foreign_key "event_registrations", "events"
  add_foreign_key "event_registrations", "users"
  add_foreign_key "events", "employers"
  add_foreign_key "experiences", "candidates"
  add_foreign_key "jobs", "employers"
  add_foreign_key "user_disabilities", "disabilities"
  add_foreign_key "user_disabilities", "users"
end
