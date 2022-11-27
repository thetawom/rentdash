class FixRentalRequestsPaymentMethod < ActiveRecord::Migration[7.0]
  def change
    change_column :rental_requests, :payment_method, :integer, null: false
    remove_column :rentals, :payment_method
  end
end
