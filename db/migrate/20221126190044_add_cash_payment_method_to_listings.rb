class AddCashPaymentMethodToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :cash, :boolean
  end
end
