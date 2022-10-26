class AddRequesterToRentalRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :rental_requests, :requester, foreign_key: { to_table: :users }, null: false
    remove_column :rental_requests, :item, :string
    change_column :rental_requests, :pick_up_date, :datetime, null: false
    change_column :rental_requests, :return_date, :datetime, null: false
  end
end
