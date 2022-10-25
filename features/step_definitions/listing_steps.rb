When /^I am at the homepage$/ do
  visit listings_path
end

Then /^I should see all the listings$/ do
  Listing.all.each do |listing|
    step %{I should see "#{listing.name}"}
  end
end