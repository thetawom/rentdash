Given /^I am on the rental requests page for "([^"]*)"$/ do |listing_name|
  step %{I go to the rental requests page for "#{listing_name}"}
end

Given /^I am on the new rental request page for "([^"]*)"$/ do |listing_name|
  step %{I go to the new rental request page for "#{listing_name}"}
end

Given /^I am on the edit rental request page for "([^"]*)"$/ do |listing_name|
  step %{I go to the edit rental request page for "#{listing_name}"}
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

Given /^my rental request for "([^"]*)" is approved$/ do |listing_name|
  rental_request = find_request_with_requester_name({ email: @user_params["email"] }, listing_name)
  rental_request.update status: "approved"
end

When /^I go to the rental requests page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit listing_rental_requests_path listing.id
end

When /^I go to the new rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit new_listing_rental_request_path listing.id
end

When /^I go to the edit request page for "([^"]*)"$/ do |listing_name|
  rental_request = find_request_with_requester_name({ email: @user_params["email"] }, listing_name)
  visit edit_rental_request_path rental_request.id
end

When /^I submit a new rental request with information$/ do |rental_requests|
  rental_request = rental_requests.hashes[0]
  %w[pick_up_time return_time].each do |field|
    fill_in "rental_request_#{field}", with: rental_request[field] if rental_request.key? field
  end
  click_button "Submit Rental Request"
end

When /^I calculate the cost for a new rental request with information$/ do |rental_requests|
  rental_request = rental_requests.hashes[0]
  %w[pick_up_time return_time].each do |field|
    fill_in "rental_request_#{field}", with: rental_request[field] if rental_request.key? field
  end
  click_button "Calculate Estimated Cost"
end

When /^I go on ([^"]*) ([^"]*)'s request for "([^"]*)"$/ do |first_name, last_name, listing_name|
  rental_request = find_request_with_requester_name({ first_name: first_name, last_name: last_name }, listing_name)
  visit rental_path rental_request.id
end

Then /^I should (?:|still )be on the rental requests page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq listing_rental_requests_path listing.id
end

Then /^I should (?:|still )be on the new rental request page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq new_listing_rental_request_path listing.id
end

Then /^I should (?:|still )be on the edit request page for "([^"]*)"$/ do |listing_name|
  rental_request = find_request_with_requester_name({ email: @user_params["email"] }, listing_name)
  expect(URI.parse(current_url).path).to eq edit_rental_request_path rental_request.id
end

Then /^the pick-up time of ([^"]*) ([^"]*)'s request for "([^"]*)" should be "([^"]*)"$/ do |first_name, last_name, listing_name, pick_up_time|
  rental_request = find_request_with_requester_name({ first_name: first_name, last_name: last_name }, listing_name)
  visit rental_request_path rental_request.id
  expect(page.body).to have_content /Pick-up Time:(\s*) #{pick_up_time}/
end

Then /^I should see the status of this request as "([^"]*)"$/ do |status|
  if status == "approved"
    page.should have_css("i.text-success")
  else
    page.should have_css("i.text-danger")
  end
end

Then /^I should see that the request for "([^"]*)" was successfully updated$/ do |listing_name|
  expect(page.body).to have_content /Request for #{listing_name} was updated!/
end

Then /^I should not see a request from "([^"]*)"$/ do |name|
  page.should_not have_content /#{name}/
end

And /^"([^"]*) ([^"]*)" has ([^"]*) karma$/ do |first_name, last_name, karma|
  user = User.find_by first_name: first_name, last_name: last_name
  user.karma = karma
  user.save
end

def create_rental_requests_with_owner(owner, request_hashes, listing)
  request_hashes.each do |rental_request|
    rental_request = RentalRequest.new rental_request
    rental_request.requester_id = owner.id
    rental_request.listing_id = listing.id
    rental_request.save
  end
end

def find_request_with_requester_name(requester_hash, listing_name)
  requester = User.find_by requester_hash
  listing = Listing.find_by name: listing_name
  RentalRequest.find_by requester: requester, listing: listing
end
