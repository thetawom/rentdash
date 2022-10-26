class ChangeListingsColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :listings, :deposit_amount, :deposit
    rename_column :listings, :rental_fee, :fee
    rename_column :listings, :rental_fee_time, :fee_time
    rename_column :listings, :rental_fee_unit, :fee_unit
  end
end
