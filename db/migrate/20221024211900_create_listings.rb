class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.string :pick_up_location
      t.decimal :rental_fee
      t.integer :rental_fee_unit
      t.integer :rental_fee_time
      t.decimal :deposit_amount

      t.timestamps
    end
  end
end
