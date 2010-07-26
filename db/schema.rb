# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "campaigns", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "condition"
    t.string   "text"
    t.boolean  "active",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cars", :force => true do |t|
    t.string  "license_number"
    t.date    "registration_date"
    t.date    "inspection_date"
    t.integer "mileage"
    t.date    "last_seen"
    t.integer "contact_id"
    t.boolean "inspection_due",    :default => false
  end

  add_index "cars", ["contact_id"], :name => "cars_contact_id_fk"

  create_table "contacts", :force => true do |t|
    t.string "given_name"
    t.string "surname"
    t.string "title"
    t.string "type"
    t.string "address"
    t.string "city"
    t.string "zipcode"
    t.string "telephone"
  end

  create_table "facebook_accounts", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.string  "uid"
    t.string  "token"
  end

  add_index "facebook_accounts", ["contact_id"], :name => "index_facebook_accounts_on_contact_id", :unique => true
  add_index "facebook_accounts", ["uid"], :name => "index_facebook_accounts_on_uid"

  create_table "facebook_comments", :force => true do |t|
    t.integer  "order_id",   :null => false
    t.string   "text"
    t.string   "uid"
    t.datetime "created_at"
    t.string   "post_id"
  end

  add_index "facebook_comments", ["order_id"], :name => "index_facebook_comments_on_order_id"
  add_index "facebook_comments", ["post_id"], :name => "index_facebook_comments_on_post_id", :unique => true
  add_index "facebook_comments", ["uid"], :name => "index_facebook_comments_on_uid"

  create_table "facebook_friends", :id => false, :force => true do |t|
    t.string "uid"
    t.string "friendof"
  end

  add_index "facebook_friends", ["uid", "friendof"], :name => "index_facebook_friends_on_uid_and_friendof", :unique => true

  create_table "facebook_informations", :primary_key => "uid", :force => true do |t|
    t.date     "birthday"
    t.string   "hometown_location_city"
    t.string   "music"
    t.string   "pic"
    t.string   "quotes"
    t.string   "tv"
    t.string   "affiliations_work_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_informations", ["uid"], :name => "index_facebook_informations_on_uid", :unique => true

  create_table "invoices", :force => true do |t|
    t.integer "order_id"
    t.integer "number"
    t.string  "invoice_type"
    t.integer "amount"
    t.date    "date"
    t.boolean "special"
  end

  add_index "invoices", ["order_id"], :name => "invoices_order_id_fk"

  create_table "orders", :force => true do |t|
    t.integer "contact_id"
    t.integer "number"
  end

  add_index "orders", ["contact_id"], :name => "orders_contact_id_fk"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",               :default => false, :null => false
    t.string   "facebook_id"
  end

  add_foreign_key "cars", "contacts", :name => "cars_contact_id_fk", :dependent => :delete

  add_foreign_key "facebook_accounts", "contacts", :name => "facebook_accounts_contact_id_fk"

  add_foreign_key "facebook_comments", "orders", :name => "facebook_comments_order_id_fk"

  add_foreign_key "invoices", "orders", :name => "invoices_order_id_fk", :dependent => :delete

  add_foreign_key "orders", "contacts", :name => "orders_contact_id_fk", :dependent => :delete

end
