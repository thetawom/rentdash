Given /^the following users exist$/ do |users_table|
  create_users users_table.hashes
end

Given /^I am a (registered|logged in) user with information$/ do |logged_in, users_table|
  users_table_hashes = [users_table.hashes[0]]
  create_users users_table_hashes
  @user_params = filter_user_params users_table_hashes[0]
  step %{I am logged in} if logged_in == "logged in"
end

Given /^I am on the login page$/ do
  visit login_path
end

Given /^I am logged in$/ do
  step %{I am on the login page}
  step %{I log in with my credentials}
end

When /^I log in with credentials$/ do |credentials|
  login_with filter_credentials credentials.hashes[0]
end

When /^I log in with my credentials/ do
  login_with filter_credentials @user_params
end

When /^I register an account with information$/ do |params|
  @user_params = filter_user_params params.hashes[0]
  visit new_user_path
  @user_params.each do |key, value|
    fill_in ("user_" << key), with: value
  end
  fill_in :user_password_confirmation, with: @user_params["password"] unless @user_params.key? "password_confirmation"
  click_button "Sign Up!"
end

Then /^I should (?:|still )be on the login page$/ do
  expect(URI.parse(current_url).path).to eq login_path
end

Then /^I should (?:|still )be on the registration page$/ do
  expect(URI.parse(current_url).path).to eq new_user_path
end


def filter_user_params(params)
  params.slice("email", "first_name", "last_name", "password", "password_confirmation", "phone")
end
def filter_credentials(credentials)
  credentials.slice("email", "password")
end

def create_users(user_hashes)
  user_hashes.each do |user|
    new_user = User.create!(email: user["email"],
                 first_name: user["first_name"],
                 last_name: user["last_name"],
                 phone: user["phone"],
                 password: user["password"],
                 password_confirmation: user["password"])
    new_user.add_karma 5000
  end
end

def login_with(credentials)
  credentials.each do |key, value|
    fill_in key, with: value
  end
  click_button "Sign in!"
end