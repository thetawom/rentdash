class AddVenmoPaymentMethodToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :venmo, :boolean
  end
end
