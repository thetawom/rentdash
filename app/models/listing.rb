class Listing < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_many :rental_requests

    validates :name, presence: true
    validates :pick_up_location, presence: true
    validates :fee, presence: true
    validates :fee_unit, presence: true
    validates :fee_time, presence: true
    validates :deposit, presence: true

    validates_numericality_of :fee, greater_than_or_equal_to: 0
    validates_numericality_of :deposit, greater_than_or_equal_to: 0

    enum fee_unit: [:karma, :dollars]
    enum fee_time: [:hour, :day, :week]
    enum item_category: [:books, :clothing, :tools, :cleaning, :technology, :school]
    enum sort_category: [:newest, :price]


    def self.with_filters(category_list, payment_type_list, rental_time_list, search_term)
        if category_list == nil
            category_list = Listing.all_categories
        else
            category_list = category_list.keys
        end

        if payment_type_list == nil
            payment_type_list = [0, 1]
        else
            payment_type_list = payment_type_list.keys
        end

        if rental_time_list == nil
            rental_time_list = [0, 1, 2]
        else
            rental_time_list = rental_time_list.keys
        end

        if search_term != nil && search_term != ""
            return Listing.where(item_category: category_list, fee_unit: payment_type_list, fee_time: rental_time_list).where("name LIKE ?", "%" + search_term + "%")
        end

        return Listing.where(item_category: category_list, fee_unit: payment_type_list, fee_time: rental_time_list)
    end

    def self.all_rental_times
        return %w[hour day week]
    end

    def self.all_categories
        return %w[books clothing tools cleaning technology school]
    end
    
    def self.all_payment_types
        return %w[karma cash]
    end

end
