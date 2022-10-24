class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :item
      t.datetime :pick_up_date
      t.datetime :return_date
      t.string :payment_method

      t.timestamps
    end
  end
end
