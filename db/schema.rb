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

ActiveRecord::Schema.define(:version => 20110115193305) do

  create_table "base_settings", :force => true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "computers", :force => true do |t|
    t.string   "name"
    t.string   "mac_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
  end

  create_table "firewalls", :force => true do |t|
    t.string   "name"
    t.integer  "visibility"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lan_id"
  end

  create_table "fw_rules", :force => true do |t|
    t.integer  "order"
    t.string   "ip_table"
    t.string   "cmd"
    t.string   "chain_name"
    t.string   "in_int"
    t.string   "out_int"
    t.string   "protocol"
    t.string   "src_ip"
    t.string   "src_port"
    t.string   "dest_ip"
    t.string   "dest_port"
    t.string   "mod"
    t.string   "log"
    t.string   "log_msg"
    t.text     "description"
    t.string   "type"
    t.integer  "firewall_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "target"
    t.string   "mod_option"
    t.string   "mod_protocol"
    t.string   "tcp_flags"
    t.string   "tcp_flags_option"
    t.string   "aft_option"
    t.string   "aft_argument"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "roleable_id"
    t.string   "roleable_type"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "permissible_id"
    t.string   "permissible_type"
    t.string   "action"
    t.boolean  "granted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.string   "init_path"
    t.string   "config_path"
    t.integer  "visibility"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bin_path"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "field_name"
    t.string   "value"
    t.integer  "base_setting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "web_jobs", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.text     "body"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source"
    t.text     "format_num"
    t.string   "category"
    t.string   "start_num_img"
  end

end
