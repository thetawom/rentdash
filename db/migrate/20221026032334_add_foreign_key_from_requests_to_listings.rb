class AddForeignKeyFromRequestsToListings < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :requests, :listings, column: :listing_id
    change_column :listings, :owner_id, :integer, null: false
  end
end
