When /^I press "([^"]*)"$/ do |button|
  click_button button
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link link
end

Then /^I should see "([^"]*)"$/ do |text|
  expect(page).to have_text text
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  expect(page).to_not have_text text
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end