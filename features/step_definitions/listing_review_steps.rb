When /^I add a new review with information$/ do |listing_reviews|
  listing_review = listing_reviews.hashes[0]
  %w[review rating].each do |field|
    fill_in "listing_review_#{field}", with: listing_review[field] if listing_review.key? field
  end
  click_button "Post Review"
end

Then /^I should (?:|still )be on the new review page for "([^"]*)"$/ do |listing_name|
  listing = Listing.find_by name: listing_name
  expect(URI.parse(current_url).path).to eq new_listing_review_path listing.id
end