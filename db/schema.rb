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

ActiveRecord::Schema.define(:version => 20120115161609) do

  create_table "excluded_taxons", :force => true do |t|
    t.integer  "taxon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lsi_analyses", :force => true do |t|
    t.string   "jobid",      :limit => 9
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prunings", :force => true do |t|
    t.string   "jobid",      :limit => 9
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rogue_taxa_analyses", :force => true do |t|
    t.integer  "jobid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roguenaroks", :force => true do |t|
    t.integer  "user_id"
    t.string   "jobid",       :limit => 9
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxons", :force => true do |t|
    t.integer  "roguenarok_id"
    t.integer  "dropset"
    t.string   "name"
    t.string   "strict"
    t.string   "mr"
    t.string   "mre"
    t.string   "userdef"
    t.string   "bipart"
    t.string   "lsi_dif"
    t.string   "lsi_ent"
    t.string   "lsi_max"
    t.string   "tii"
    t.string   "support",       :limit => 1
    t.string   "n_bipart",      :limit => 1
    t.string   "excluded",      :limit => 1, :default => "F"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tii_analyses", :force => true do |t|
    t.string   "jobid"
    t.string   "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "ip"
    t.integer  "saved_subs"
    t.integer  "all_subs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
