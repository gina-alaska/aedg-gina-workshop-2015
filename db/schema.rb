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

ActiveRecord::Schema.define(version: 20150312201917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pces", force: :cascade do |t|
    t.integer  "gnis_feature_id"
    t.string   "community_name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "plant_name"
    t.integer  "year"
    t.integer  "month"
    t.string   "season"
    t.float    "fuel_used_gal"
    t.integer  "residential_kwh_sold"
    t.integer  "commercial_kwh_sold"
    t.integer  "community_kwh_sold"
    t.integer  "government_kwh_sold"
    t.date     "date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
