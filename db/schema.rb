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

ActiveRecord::Schema[7.0].define(version: 2022_06_21_174036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "databases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "adapter"
    t.string "database"
    t.string "username"
    t.string "password"
    t.string "host"
    t.integer "port"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["name"], name: "index_databases_on_name"
    t.index ["user_id"], name: "index_databases_on_user_id"
  end

  create_table "report_exports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "report_id", null: false
    t.uuid "user_id", null: false
    t.string "export_context"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_exports_on_report_id"
    t.index ["user_id"], name: "index_report_exports_on_user_id"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "query"
    t.text "subject"
    t.jsonb "to_recipients"
    t.jsonb "cc_recipients"
    t.jsonb "bcc_recipients"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule_day"
    t.time "schedule_time"
    t.string "schedule_type"
    t.datetime "last_reported_at"
    t.uuid "user_id", null: false
    t.datetime "deleted_at"
    t.datetime "failure_last_notified_at"
    t.uuid "database_id", null: false
    t.datetime "last_edited_at"
    t.uuid "last_edited_by_user_id"
    t.index ["database_id"], name: "index_reports_on_database_id"
    t.index ["deleted_at"], name: "index_reports_on_deleted_at"
    t.index ["failure_last_notified_at"], name: "index_reports_on_failure_last_notified_at"
    t.index ["last_reported_at"], name: "index_reports_on_last_reported_at"
    t.index ["schedule_day"], name: "index_reports_on_schedule_day"
    t.index ["schedule_time"], name: "index_reports_on_schedule_time"
    t.index ["schedule_type"], name: "index_reports_on_schedule_type"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "admin"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "databases", "users"
  add_foreign_key "reports", "users"
end
