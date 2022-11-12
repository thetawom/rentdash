class SetListingsItemCategoryToNonNull < ActiveRecord::Migration[7.0]
  def change
    change_column :listings, :item_category, :integer, null: false, default: 0
  end
end
