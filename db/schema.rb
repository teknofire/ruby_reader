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

ActiveRecord::Schema.define(version: 20130614090733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published"
    t.string   "categories"
    t.text     "url"
    t.integer  "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feeds", force: true do |t|
    t.string   "title"
    t.text     "url"
    t.string   "feed_url"
    t.string   "etag"
    t.datetime "last_modified"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
