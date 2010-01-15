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

ActiveRecord::Schema.define(:version => 20100113093713) do

  create_table "agreements", :force => true do |t|
    t.integer  "client_id",             :null => false
    t.integer  "product_id",            :null => false
    t.string   "description",           :null => false
    t.date     "start_date",            :null => false
    t.date     "next_period_starts_on", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "remote_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true, :null => false
  end

  add_index "clients", ["remote_id"], :name => "index_clients_on_remote_id", :unique => true

  create_table "log_items", :force => true do |t|
    t.integer  "agreement_id"
    t.string   "action"
    t.string   "message",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.integer  "amount",     :null => false
    t.string   "tax_rate",   :null => false
    t.string   "interval",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["code"], :name => "index_products_on_code", :unique => true

  create_table "sequences", :force => true do |t|
  end

end
