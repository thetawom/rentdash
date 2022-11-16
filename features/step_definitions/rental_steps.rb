Given /^"([^"]*) ([^"]*)" has the following ([^"]*) rental requests for "([^"]*)"$/ do |first_name, last_name, status, listing_name, rental_requests_table|
  owner = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  create_rentals owner, status, rental_requests_table.hashes, listing
end

When(/^I go on ([^"]*) ([^"]*)'s rental for "([^"]*)"$/) do |first_name, last_name, listing_name|
  renter = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  rental = Rental.find_by listing_id: listing.id, renter_id: renter.id
  visit rental_path rental.id
end

Then /^I should (not )?see "([^"]*)" in ([^"]*)$/ do |not_exists, listing_name, category|
  if not_exists.nil?
    page.should have_content find("##{category}").first("div", text: listing_name).text
  end
end

Then /^I should be on my rental page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  rental = Rental.find_by listing: listing
  expect(URI.parse(current_url).path).to eq rental_path rental.id
end

Then /^I should see that the rental is cancelled$/ do
  page.should have_content "Status: cancelled"
end

And /^I follow "([^"]*)" for "([^"]*)"$/ do |link, listing_name|
  first("div", text: listing_name).first("a", text: link).click
end

def create_rentals (owner, status, request_hashes, listing)
  request_hashes.each do |request|
    request = RentalRequest.new request
    request.requester_id = owner.id
    request.listing_id = listing.id
    request.save
    if status == "approved"
      request.approve
    end
  end
end