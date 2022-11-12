class SetIntegerFieldsToNonNull < ActiveRecord::Migration[7.0]
  def change
    change_column :rentals, :status, :integer, null: false, default: 0
    change_column :listings, :fee, :decimal, null: false
    change_column :listings, :fee_unit, :integer, null: false
    change_column :listings, :fee_time, :integer, null: false
    change_column :listings, :deposit, :decimal, null: false, default: 0
  end
end
