class CreateListingReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :listing_reviews do |t|
      t.text :review
      t.integer :rating, null: false
      t.integer :listing_id, null: false
      t.integer :user_id, null: false

      t.timestamps

      t.index ["listing_id"], name: "index_listing_reviews_on_listing_id"
      t.index ["user_id"], name: "index_listing_reviews_on_user_id"
    end

    add_foreign_key "listing_reviews", "listings", column: "listing_id"
    add_foreign_key "listing_reviews", "users", column: "user_id"
  end
end
