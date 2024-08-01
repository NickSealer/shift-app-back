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

ActiveRecord::Schema[7.1].define(version: 2024_07_29_180712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_assigments_on_service_id"
    t.index ["user_id"], name: "index_assigments_on_user_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "week"
    t.integer "year"
    t.date "from"
    t.date "to"
    t.boolean "confirmed", default: false
    t.bigint "user_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_availabilities_on_service_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "days", force: :cascade do |t|
    t.date "date"
    t.string "day_name"
    t.string "time"
    t.boolean "available", default: false
    t.bigint "availability_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_days_on_availability_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "monday", default: [], array: true
    t.string "tuesday", default: [], array: true
    t.string "wednesday", default: [], array: true
    t.string "thursday", default: [], array: true
    t.string "friday", default: [], array: true
    t.string "saturday", default: [], array: true
    t.string "sunday", default: [], array: true
    t.integer "total_hours", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friday"], name: "index_services_on_friday", using: :gin
    t.index ["monday"], name: "index_services_on_monday", using: :gin
    t.index ["saturday"], name: "index_services_on_saturday", using: :gin
    t.index ["sunday"], name: "index_services_on_sunday", using: :gin
    t.index ["thursday"], name: "index_services_on_thursday", using: :gin
    t.index ["tuesday"], name: "index_services_on_tuesday", using: :gin
    t.index ["wednesday"], name: "index_services_on_wednesday", using: :gin
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "week"
    t.integer "year"
    t.boolean "confirmed", default: false
    t.bigint "service_id", null: false
    t.bigint "admin_id", null: false
    t.jsonb "data", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_shifts_on_admin_id"
    t.index ["data"], name: "index_shifts_on_data", using: :gin
    t.index ["service_id"], name: "index_shifts_on_service_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "lastname"
    t.string "email"
    t.integer "role", default: 0
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "availabilities", "services"
  add_foreign_key "availabilities", "users"
  add_foreign_key "days", "availabilities"
  add_foreign_key "shifts", "services"
end
