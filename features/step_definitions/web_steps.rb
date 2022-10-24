When /^I press "([^"]*)"$/ do |button|
  click_button button
end

Then /^I should see "([^"]*)"$/ do |text|
  expect(page).to have_text text
end