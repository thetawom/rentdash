class AddStatusToRentalRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :rental_requests, :status, :integer, null: false, default: 0
  end
end
