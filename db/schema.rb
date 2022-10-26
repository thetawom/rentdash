# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_26_150805) do
  create_table "listings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "pick_up_location"
    t.decimal "fee"
    t.integer "fee_unit"
    t.integer "fee_time"
    t.decimal "deposit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.index ["owner_id"], name: "index_listings_on_owner_id"
  end

  create_table "rental_requests", force: :cascade do |t|
    t.datetime "pick_up_date", null: false
    t.datetime "return_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "listing_id", null: false
    t.integer "requester_id", null: false
    t.index ["listing_id"], name: "index_rental_requests_on_listing_id"
    t.index ["requester_id"], name: "index_rental_requests_on_requester_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "listings", "users", column: "owner_id"
  add_foreign_key "rental_requests", "listings"
  add_foreign_key "rental_requests", "users", column: "requester_id"
end
