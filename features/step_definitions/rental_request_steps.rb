Given /^I am on the new rental request page for "([^"]*)"$/ do |listing_name|
  step %{I go to the new rental request page for "#{listing_name}"}
end

Given /^I have the following rental requests for "([^"]*)"$/ do |listing_name, rental_requests_table|
  owner = User.find_by email: @user_params["email"]
  listing = Listing.find_by name: listing_name
  create_rental_requests_with_owner owner, rental_requests_table.hashes, listing
end

Given /^"([^"]*) ([^"]*)" has the following rental requests for "([^"]*)"$/ do |first_name, last_name, listing_name, rental_requests_table|
  owner = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  create_rental_requests_with_owner owner, rental_requests_table.hashes, listing
end

When /^I go to the new rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit new_listing_rental_request_path listing.id
end

When /^I add a new rental request with information$/ do |rental_requests|
  rental_request = rental_requests.hashes[0]
  %w[pick_up_date return_date].each do |field|
    fill_in "rental_request_#{field}", with: rental_request[field] if rental_request.key? field
  end
  click_button "Submit Rental Request"
end

Then /^I should (?:|still )be on my rental requests page$/ do
  expect(URI.parse(current_url).path).to eq my_requests_path
end

Then /^I should (?:|still )be on the new rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq new_listing_rental_request_path listing.id
end


def create_rental_requests_with_owner(owner, request_hashes, listing)
  request_hashes.each do |request|
    request = RentalRequest.new request
    request.requester_id = owner.id
    request.listing_id = listing.id
    request.save
  end
end