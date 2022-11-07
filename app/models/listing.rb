class Listing < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_many :rental_requests

    validates :name, presence: true
    validates :pick_up_location, presence: true
    validates :fee, presence: true
    validates :fee_unit, presence: true
    validates :fee_time, presence: true
    validates :deposit, presence: true
    validates :item_category, presence: true

    validates_numericality_of :fee, greater_than_or_equal_to: 0
    validates_numericality_of :deposit, greater_than_or_equal_to: 0

    enum fee_unit: [:karma, :dollars]
    enum fee_time: [:hour, :day, :week]
    enum item_category: [:books, :clothing, :tools, :cleaning, :technology, :school]

    def self.with_filters(category_list, payment_type_list, rental_time_list)
        if category_list == nil && payment_type_list == nil && rental_time_list == nil
            return Listing.all
        
        elsif category_list == nil && payment_type_list == nil
            return Listing.where(fee_time: rental_time_list.keys)
        
        elsif category_list == nil && rental_time_list == nil
            return Listing.where(fee_unit: payment_type_list.keys)
        
        elsif payment_type_list == nil && rental_time_list == nil
            return Listing.where(item_category: category_list.keys)
        
        elsif category_list == nil
            return Listing.where(fee_time: rental_time_list.keys, fee_unit: payment_type_list.keys)
        
        elsif payment_type_list == nil
            return Listing.where(item_category: category_list.keys, fee_time: rental_time_list.keys)
        
        elsif rental_time_list == nil
            return Listing.where(item_category: category_list.keys, fee_unit: payment_type_list.keys)
        end

        Listing.where(item_category: category_list.keys, fee_unit: payment_type_list.keys, fee_time: rental_time_list.keys)
    end

    def self.all_rental_times()
        return ['hour', 'day', 'week']
    end

    def self.all_categories()
        return ['books', 'clothing', 'tools', 'cleaning', 'technology', 'school']
    end
    
    def self.all_payment_types()
        return ['karma', 'cash']
    end

end
