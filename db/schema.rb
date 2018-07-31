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

ActiveRecord::Schema.define(version: 2018_07_31_134628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grapes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trip_wineries", force: :cascade do |t|
    t.integer "trip_id"
    t.integer "winery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "wine_from_apis", force: :cascade do |t|
    t.integer "sequence"
    t.string "area"
    t.string "country"
    t.string "name"
    t.string "province"
    t.string "style"
    t.string "wine_type"
    t.string "varietal"
    t.string "winery"
    t.string "api_id"
    t.string "vintage"
    t.string "region"
  end

  create_table "wineries", force: :cascade do |t|
    t.string "name"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area"
    t.string "country"
    t.string "province"
    t.integer "api_sequence"
  end

  create_table "wines", force: :cascade do |t|
    t.string "name"
    t.string "wine_type"
    t.string "style"
    t.string "api_id"
    t.integer "winery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vintage"
    t.integer "grape_id"
  end

end
