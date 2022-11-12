Given /^I am on the listings page$/ do
  step %{I go to the listings page}
end

Given /^I am on the new listing page$/ do
  step %{I go to the new listing page}
end

Given /^I am on the listing page for "([^"]*)"$/ do |listing_name|
  step %{I go to the listing page for "#{listing_name}"}
end

Given /^I am on the edit listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit edit_listing_path listing.id
end

Given /^I have the following listings$/ do |listings_table|
  owner = User.find_by email: @user_params["email"]
  create_listings_with_owner owner, listings_table.hashes
end

Given /^"([^"]*) ([^"]*)" has the following listings$/ do |first_name, last_name, listings_table|
  owner = User.find_by first_name: first_name, last_name: last_name
  create_listings_with_owner owner, listings_table.hashes
end

When /^I go to the listings page$/ do
  visit listings_path
end

When /^I go to the new listing page$/ do
  visit new_listing_path
end

When /^I go to the listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit listing_path listing.id
end

When /^I go to the edit listing page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  visit edit_listing_path listing.id
end

When /^I add a new listing with information$/ do |listings|
  listing = listings.hashes[0]
  %w[name description pick_up_location fee deposit].each do |field|
    fill_in "listing_#{field}", with: listing[field] if listing.key? field
  end
  %w[fee_unit fee_time item_category].each do |field|
    select listing[field], from: "listing_#{field}" if listing.key? field
  end
  click_button "Add Listing"
end

When /I (un)?check the following currencies: (.*)/ do |uncheck, filter_list|
  filter_list.split(", ").each do |filter|
    if uncheck == false
      step %Q{I check "#{filter}"}
    else
      step %Q{I uncheck "#{filter}"}
    end
  end
end

When /I (un)?check the following time units: (.*)/ do |uncheck, filter_list|
  filter_list.split(", ").each do |filter|
    if uncheck == false
      step %Q{I check "#{filter}"}
    else
      step %Q{I uncheck "#{filter}"}
    end
  end
end

When /I (un)?check the following item categories: (.*)/ do |uncheck, filter_list|
  filter_list.split(", ").each do |filter|
    if uncheck == false
      step %Q{I check "#{filter}"}
    else
      step %Q{I uncheck "#{filter}"}
    end
  end
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
    expect(page.find_by_id("main")).to_not have_text listing_name
  end
end

Then /^I should see all the listings$/ do
  Listing.all.each do |listing|
    step %{I should see a listing for "#{listing.name}"}
  end
end

Then /^I should see all my listings$/ do
  owner = User.find_by email: @user_params["email"]
  Listing.where(owner_id: owner.id).each do |listing|
    step %{I should see a listing for "#{listing.name}"}
  end
end

Then /^I should (not )?see the following listings: (.*)$/ do |no, listings_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  listings_list.split(", ").each do |listing|
    if no == false
      step %Q{I should not see "#{listing}"}
    else
      step %Q{I should see "#{listing}"}
    end
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  expect(page.body) =~ regexp
end

Then /^the pick-up location of "(.*)" should be "(.*)"$/ do |listing_name, location|
  listing = Listing.find_by name: listing_name
  visit listing_path listing.id
  expect(page.body).to match /Pick-up Location:(\s*)#{location}/
end

def create_listings_with_owner(owner, listing_hashes)
  listing_hashes.each do |listing|
    listing = Listing.new listing
    listing.owner_id = owner.id
    listing.save
  end
end