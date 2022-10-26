class ChangeRequestsToRentalRequests < ActiveRecord::Migration[7.0]
  def change
    rename_table :requests, :rental_requests
    change_column :rental_requests, :listing_id, :integer, null: false
  end
end
