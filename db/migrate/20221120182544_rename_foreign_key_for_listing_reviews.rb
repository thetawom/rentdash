class RenameForeignKeyForListingReviews < ActiveRecord::Migration[7.0]
  def change
    rename_column :listing_reviews, :user_id, :reviewer_id
  end
end
