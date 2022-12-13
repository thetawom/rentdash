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

ActiveRecord::Schema[7.0].define(version: 2022_12_09_224138) do
  create_table "listing_reviews", force: :cascade do |t|
    t.text "review"
    t.integer "rating", null: false
    t.integer "listing_id", null: false
    t.integer "reviewer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_listing_reviews_on_listing_id"
    t.index ["reviewer_id"], name: "index_listing_reviews_on_reviewer_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "pick_up_location"
    t.decimal "fee", null: false
    t.integer "fee_unit", null: false
    t.integer "fee_time", null: false
    t.decimal "deposit", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.integer "item_category", default: 0, null: false
    t.boolean "venmo"
    t.boolean "paypal"
    t.boolean "cash"
    t.index ["owner_id"], name: "index_listings_on_owner_id"
  end

  create_table "rental_requests", force: :cascade do |t|
    t.datetime "pick_up_time", null: false
    t.datetime "return_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "listing_id", null: false
    t.integer "requester_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "payment_method", null: false
    t.index ["listing_id"], name: "index_rental_requests_on_listing_id"
    t.index ["requester_id"], name: "index_rental_requests_on_requester_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "listing_id", default: 0, null: false
    t.integer "request_id", default: 0, null: false
    t.integer "renter_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_rentals_on_listing_id"
    t.index ["renter_id"], name: "index_rentals_on_renter_id"
    t.index ["request_id"], name: "index_rentals_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "karma", default: 0, null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "listing_reviews", "listings"
  add_foreign_key "listing_reviews", "users", column: "reviewer_id"
  add_foreign_key "listings", "users", column: "owner_id"
  add_foreign_key "rental_requests", "listings"
  add_foreign_key "rental_requests", "users", column: "requester_id"
  add_foreign_key "rentals", "listings"
  add_foreign_key "rentals", "rental_requests", column: "request_id"
  add_foreign_key "rentals", "users", column: "renter_id"
end
