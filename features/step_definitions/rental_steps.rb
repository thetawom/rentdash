Given /^I am on my rentals page$/ do
  step %{I go to my rentals page}
end

When /^I got to my rentals page$/ do
  visit rentals_path
end

Then /^I should (?:|still )be on my rentals page$/ do
  expect(URI.parse(current_url).path).to eq rentals_path
end

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

Then(/^I should see that updating "([^"]*)" was (un)?successful$/) do |listing_name, un_exists|
  if un_exists.nil?
    expect(page.body).to have_content /Request for #{listing_name} was updated!/
  else
    expect(page.body).to have_content /can't be blank/ or expect(page.body).to have_content /must be/
  end
end

And /^I follow "([^"]*)" for "([^"]*)"$/ do |link, listing_name|
  first("div", text: listing_name).first("a", text: link).click
end

And /^I change the status to "([^"]*)"$/ do |status|
  select status, from: "Status"
end

And /^I change the pick-up time$/ do
  fill_in "Pick-up Time", with: ""
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