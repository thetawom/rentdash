module RentalRequestsHelper
    def payment_method_options_new_rental(listing)
        l = []

        if listing.venmo == true
            l.append("venmo")
        end

        if listing.paypal == true
            l.append("paypal")
        end

        if listing.cash == true
            l.append("cash")
        end

        options_for_select(l.map{|key, value| [key.titleize, key]})
    end

    def payment_method_options_edit_rental(listing, request)
        l = []

        if listing.venmo == true
            l.append("venmo")
        end

        if listing.paypal == true
            l.append("paypal")
        end

        if listing.cash == true
            l.append("cash")
        end

        options_for_select(l.map{|key, value| [key.titleize, key]}, request.payment_method)
    end




end