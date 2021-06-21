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

ActiveRecord::Schema.define(version: 2021_02_23_132035) do

  create_table "care_receivers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.date "birthday", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_care_receivers_on_discarded_at"
  end

  create_table "dosing_times", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.time "time", null: false
    t.integer "timeframe_id", limit: 2, null: false
    t.bigint "care_receiver_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["care_receiver_id"], name: "index_dosing_times_on_care_receiver_id"
    t.index ["discarded_at"], name: "index_dosing_times_on_discarded_at"
    t.index ["time", "care_receiver_id", "discarded_at"], name: "index_dosing_time_time_care_receiver_discard", unique: true
    t.index ["timeframe_id", "care_receiver_id", "discarded_at"], name: "index_dosing_time_timeframe_care_receiver_discard", unique: true
  end

  create_table "medicine_dosing_times", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "medicine_id", null: false
    t.bigint "dosing_time_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_medicine_dosing_times_on_discarded_at"
    t.index ["dosing_time_id"], name: "index_medicine_dosing_times_on_dosing_time_id"
    t.index ["medicine_id"], name: "index_medicine_dosing_times_on_medicine_id"
  end

  create_table "medicines", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "image"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_medicines_on_discarded_at"
    t.index ["name", "discarded_at"], name: "index_medicines_on_name_and_discarded_at", unique: true
  end

  create_table "takes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "execute", default: false, null: false
    t.string "dosing_timeframe", null: false
    t.time "dosing_time", null: false
    t.bigint "user_id", null: false
    t.bigint "care_receiver_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["care_receiver_id"], name: "index_takes_on_care_receiver_id"
    t.index ["user_id"], name: "index_takes_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "employee_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.string "status"
    t.index ["employee_id"], name: "index_users_on_employee_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dosing_times", "care_receivers"
  add_foreign_key "medicine_dosing_times", "dosing_times"
  add_foreign_key "medicine_dosing_times", "medicines"
  add_foreign_key "takes", "care_receivers"
  add_foreign_key "takes", "users"
end
