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

ActiveRecord::Schema[7.0].define(version: 2022_05_29_112934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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
    t.index ["last_reported_at"], name: "index_reports_on_last_reported_at"
    t.index ["schedule_day"], name: "index_reports_on_schedule_day"
    t.index ["schedule_time"], name: "index_reports_on_schedule_time"
    t.index ["schedule_type"], name: "index_reports_on_schedule_type"
  end

end
