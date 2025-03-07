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

ActiveRecord::Schema[8.0].define(version: 2025_03_07_080716) do
  create_table "addresses", force: :cascade do |t|
    t.string "zip", null: false
    t.string "town", null: false
    t.string "street", null: false
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.integer "week_day", null: false
    t.integer "classe_id", null: false
    t.integer "subject_id", null: false
    t.integer "moment_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classe_id"], name: "index_courses_on_classe_id"
    t.index ["moment_id"], name: "index_courses_on_moment_id"
    t.index ["person_id"], name: "index_courses_on_person_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
  end

  create_table "examinations", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "expected_at", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_examinations_on_course_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "value", null: false
    t.datetime "expected_at", null: false
    t.integer "examination_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examination_id"], name: "index_grades_on_examination_id"
    t.index ["person_id"], name: "index_grades_on_person_id"
  end

  create_table "moments", force: :cascade do |t|
    t.string "uid", null: false
    t.integer "category", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "phone_number", null: false
    t.integer "role", null: false
    t.string "iban"
    t.integer "address_id", null: false
    t.index ["address_id"], name: "index_people_on_address_id"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
  end

  create_table "people_school_classes", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "school_class_id", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "school_classes", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.integer "person_id", null: false
    t.integer "room_id", null: false
    t.integer "moment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moment_id"], name: "index_school_classes_on_moment_id"
    t.index ["person_id"], name: "index_school_classes_on_person_id"
    t.index ["room_id"], name: "index_school_classes_on_room_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "courses", "classes", column: "classe_id"
  add_foreign_key "courses", "moments"
  add_foreign_key "courses", "people"
  add_foreign_key "courses", "subjects"
  add_foreign_key "examinations", "courses"
  add_foreign_key "grades", "examinations"
  add_foreign_key "grades", "people"
  add_foreign_key "people", "addresses"
  add_foreign_key "school_classes", "moments"
  add_foreign_key "school_classes", "people"
  add_foreign_key "school_classes", "rooms"
end
