class Rename < ActiveRecord::Migration[7.0]
  def change
    rename_column :rental_requests, :pick_up_date, :pick_up_time
    rename_column :rental_requests, :return_date, :return_time
  end
end
