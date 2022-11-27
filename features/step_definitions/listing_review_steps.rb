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

Then /^I should not see an? ([^"]*) button for "([^"]*)'s" review$/ do |button, name|
  first(".card-body").find(".card-title", text: name).should_not have_content button
end

And /^I have the following review for "([^"]*)"$/ do |listing_name, reviews_table|
  # table is a table.hashes.keys # => [:review, :rating]
  owner = User.find_by email: @user_params["email"]
  listing = Listing.find_by name: listing_name
  create_reviews owner, reviews_table.hashes, listing
end

And /^"([^"]*) ([^"]*)" has the following review for "([^"]*)"$/ do |first_name, last_name, listing_name, reviews_table|
  owner = User.find_by first_name: first_name, last_name: last_name
  listing = Listing.find_by name: listing_name
  create_reviews owner, reviews_table.hashes, listing
end

And /^I change the rating to "([^"]*)"$/ do |rating|
  fill_in "listing_review[rating]", with: rating
end

def create_reviews (owner, review_hashes, listing)
  review_hashes.each do |listing_review|
    listing_review = ListingReview.new listing_review
    listing_review.listing_id = listing.id
    listing_review.reviewer_id = owner.id
    listing_review.save
  end
end