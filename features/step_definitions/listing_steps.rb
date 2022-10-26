Given /^I am on the listings page$/ do
  visit listings_path
end

Given /^I am on the new listing page$/ do
  visit new_listing_path
end

Given /^I am on the listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit listing_path listing.id
end

Given /^I am on the edit listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit edit_listing_path listing.id
end

Given /^the following listings exist$/ do |listings_table|
  expect(User.find_by(id: 1)).to_not be_nil
  listings_table.hashes.each do |listing|
    listing = Listing.new listing
    listing.owner_id = 1
    listing.save
  end
end

When /^I add a new listing with information$/ do |listings|
  listing = listings.hashes[0]
  %w[name description pick_up_location fee deposit].each do |field|
    fill_in "listing_#{field}", with: listing[field] if listing.key? field
  end
  %w[fee_unit fee_time].each do |field|
    select listing[field], from: "listing_#{field}" if listing.key? field
  end
  click_button "Add Listing"
end

Then /^I should (?:|still )be on the listings page$/ do
  expect(URI.parse(current_url).path).to eq listings_path
end

Then /^I should (?:|still )be on the new listing page$/ do
  expect(URI.parse(current_url).path).to eq new_listing_path
end

Then /^I should (?:|still )be on the listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq listing_path listing.id
end

Then /^I should (?:|still )be on the edit listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by(name: listing_name)
  expect(URI.parse(current_url).path).to eq edit_listing_path listing.id
end

Then /^I should (not )?see a listing for "([^"]*)"$/ do |not_exists, listing_name|
  if not_exists.nil?
    expect(page).to have_text listing_name
  else
    expect(page).to_not have_text listing_name
  end
end

Then /^I should see all the listings$/ do
  Listing.all.each do |listing|
    step %{I should see a listing for "#{listing.name}"}
  end
end

Then /^the pick-up location of "(.*)" should be "(.*)"$/ do |listing_name, location|
  listing = Listing.find_by name: listing_name
  visit listing_path listing.id
  expect(page.body).to match /Pick-up Location:(\s*)#{location}/
end

Then /^I should see the error (.*)$/ do |error|
  expect(page.body).to have_text error
end