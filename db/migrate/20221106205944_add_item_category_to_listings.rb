class AddItemCategoryToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :item_category, :integer
  end
end
