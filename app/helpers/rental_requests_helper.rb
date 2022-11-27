module RentalRequestsHelper
    def payment_method_options(listing, request = nil)
        options_for_select(listing.accepted_payment_methods.map{|key, value| [key.titleize, key]}, request&.payment_method)
    end

end