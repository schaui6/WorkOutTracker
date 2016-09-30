# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160605035610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "measurements", force: :cascade do |t|
    t.float    "weight"
    t.float    "wrist"
    t.float    "forearm"
    t.float    "height"
    t.float    "neck"
    t.float    "waist"
    t.float    "left_arm"
    t.float    "right_arm"
    t.float    "hips"
    t.float    "chest"
    t.float    "right_thigh"
    t.float    "left_thigh"
    t.float    "body_fat"
    t.float    "dead_lift"
    t.float    "bench_press"
    t.float    "squat"
    t.float    "lat_pull"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "progresses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "measurement_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "gender"
    t.integer  "age"
    t.float    "height"
    t.float    "weight"
    t.float    "waist"
    t.float    "wrist"
    t.float    "forearm"
    t.float    "body_fat"
    t.float    "neck"
    t.float    "chest"
    t.float    "hips"
    t.boolean  "admin",               default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "workouts", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "reps",                       null: false
    t.integer  "sets",                       null: false
    t.string   "weight",                     null: false
    t.boolean  "completed",  default: false
    t.integer  "user_id"
    t.integer  "phase",                      null: false
    t.integer  "rest",                       null: false
    t.integer  "day",                        null: false
    t.string   "note"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
