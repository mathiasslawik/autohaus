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

ActiveRecord::Schema.define(:version => 4) do

  create_table "cars", :force => true do |t|
    t.string  "license_number"
    t.date    "registration_date"
    t.date    "inspection_date"
    t.integer "mileage"
    t.date    "last_seen"
    t.integer "contact_id"
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

  add_foreign_key "invoices", "orders", :name => "invoices_order_id_fk", :dependent => :delete

  add_foreign_key "orders", "contacts", :name => "orders_contact_id_fk", :dependent => :delete

end
