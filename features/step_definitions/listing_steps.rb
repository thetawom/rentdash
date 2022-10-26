Given /^I am on the listings page$/ do
  visit listings_path
end

Given /^I am on the new listing page$/ do
  visit new_listing_path
end

When /^I add a new listing with information$/ do |params|
  params = params.rows_hash
  %w[name description pick_up_location fee deposit].each do |field|
    fill_in "listing_#{field}", with: params[field] if params.key? field
  end
  %w[fee_unit fee_time].each do |field|
    select params[field], from: "listing_#{field}" if params.key? field
  end
  click_button "Add Listing"
end

Then /^I should be on the listings page$/ do
  expect(URI.parse(current_url).path).to eq listings_path
end

Then /^I should be on the new listing page$/ do
  expect(URI.parse(current_url).path).to eq new_listing_path
end

Then /^I should see a listing for "([^"]*)"$/ do |listing_name|
  expect(page).to have_text listing_name
end

Then /^I should see all the listings$/ do
  Listing.all.each do |listing|
    step %{I should see a listing for "#{listing.name}"}
  end
end

Given /^the following listings exist$/ do |listings_table|
  listings_table.hashes.each do |listing|
    listing = Listing.new listing
    listing.owner_id = 1
    listing.save
  end
end

Then /the pick-up location of "(.*)" should be "(.*)"/ do |name, location|
  listing = Listing.find_by name: name
  visit listing_path(listing.id)
  expect(page.body).to match /Pick-up Location:(\s*)#{location}/
end