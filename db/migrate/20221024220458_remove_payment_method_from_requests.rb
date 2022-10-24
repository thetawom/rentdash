class RemovePaymentMethodFromRequests < ActiveRecord::Migration[7.0]
  def change
    remove_column :requests, :payment_method
  end
end
