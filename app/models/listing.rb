class Listing < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_many :rental_requests, dependent: :destroy
    has_many :rentals, dependent: :destroy

    validates :name, presence: true
    validates :pick_up_location, presence: true
    validates :fee, presence: true
    validates :fee_unit, presence: true
    validates :fee_time, presence: true
    validates :deposit, presence: true
    validates :item_category, presence: true

    validates_numericality_of :fee, greater_than_or_equal_to: 0
    validates_numericality_of :deposit, greater_than_or_equal_to: 0

    enum item_category: [:other, :books, :clothing, :tools, :cleaning, :technology, :school]
    enum fee_unit: [:karma, :dollars]
    enum fee_time: [:hour, :day, :week]

    def self.with_filters(categories, fee_units, fee_times, search_term=nil)
        categories = self.all_item_categories if categories.nil?
        fee_units = self.all_fee_units if fee_units.nil?
        fee_times = self.all_fee_times if fee_times.nil?
        listings = where item_category: self.item_categories.values_at(*categories),
                         fee_unit: self.fee_units.values_at(*fee_units),
                         fee_time: self.fee_times.values_at(*fee_times)
        listings = listings.where("name LIKE ?", "%#{search_term}%") unless search_term.nil?
        listings
    end

    def self.all_item_categories
        self.item_categories.keys
    end

    def self.all_fee_units
        self.fee_units.keys
    end

    def self.all_fee_times
        self.fee_times.keys
    end

end
