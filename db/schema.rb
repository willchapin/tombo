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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130818212339) do

  create_table "comments", :force => true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.text     "content",    :limit => 255
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "comments", ["track_id", "created_at"], :name => "index_comments_on_track_id_and_created_at"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id", "follower_id"], :name => "index_relationships_on_followed_id_and_follower_id", :unique => true
  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "tracks", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "track_file_file_name"
    t.string   "track_file_content_type"
    t.integer  "track_file_file_size"
    t.datetime "track_file_updated_at"
    t.text     "description",             :limit => 255
  end

  add_index "tracks", ["id"], :name => "index_tracks_on_id", :unique => true
  add_index "tracks", ["user_id", "created_at"], :name => "index_tracks_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                          :default => false
    t.text     "bio",             :limit => 255
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
