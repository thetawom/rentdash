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
  %w[pick_up_time return_time].each do |field|
    fill_in "rental_request_#{field}", with: rental_request[field] if rental_request.key? field
  end
  click_button "Submit Rental Request"
end

Then /^I should (?:|still )be on my rentals page$/ do
  expect(URI.parse(current_url).path).to eq rentals_path
end

Then /^I should (?:|still )be on my rental requests page$/ do
  expect(URI.parse(current_url).path).to eq my_requests_path
end

Then /^I should (?:|still )be on the rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq listing_rental_requests_path listing.id
end

Then /^I should (?:|still )be on the new rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq new_listing_rental_request_path listing.id
end

Then(/^I should be on ([^"]*) ([^"]*)'s request page for "([^"]*)"$/) do |first_name, last_name, listing_name|
  requester = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  request = RentalRequest.find_by requester: requester, listing: listing
  visit rental_request_path request.id
end

Then(/^the pick-up time of ([^"]*) ([^"]*)'s request for "([^"]*)" should be "([^"]*)"$/) do |first_name, last_name, listing_name, pick_up_time|
  requester = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  request = RentalRequest.find_by requester: requester, listing: listing
  visit rental_request_path request.id
  expect(page.body).to have_content /Pick-up Time:(\s*) #{pick_up_time}/
end

Then /^I should see the status of this request as "([^"]*)"$/ do |status|
  if status == "approved"
    page.should have_css("i.text-success")
  else
    page.should have_css("i.text-danger")
  end
end

def create_rental_requests_with_owner(owner, request_hashes, listing)
  request_hashes.each do |request|
    request = RentalRequest.new request
    request.requester_id = owner.id
    request.listing_id = listing.id
    request.save
  end
end
