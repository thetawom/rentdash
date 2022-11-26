class AddPaymentMethodToRentalRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :rental_requests, :payment_method, :string
  end
end
