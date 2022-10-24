class AddListingIdToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :listing_id, :integer
    add_index :requests, :listing_id
  end
end
