class AddPayPalPaymentMethodToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :paypal, :boolean
  end
end
