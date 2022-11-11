class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.integer :payment_method
      t.integer :status
      t.references :listing, null: false, default: 0
      t.references :request, null: false, default: 0
      t.references :renter, null: false, default: 0

      t.timestamps
    end
    add_foreign_key :rentals, :listings, column: :listing_id
    add_foreign_key :rentals, :rental_requests, column: :request_id
    add_foreign_key :rentals, :users, column: :renter_id
  end
end