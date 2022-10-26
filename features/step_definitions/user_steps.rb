Given /^I am a registered user with information$/ do |params|
  @user_params = filter_user_params params.rows_hash
  @user = User.create!(email: @user_params["email"],
                       first_name: @user_params["first_name"],
                       last_name: @user_params["last_name"],
                       password: @user_params["password"],
                       password_confirmation: @user_params["password"])
end

When /^I log in with credentials$/ do |credentials|
  visit login_path
  login_with filter_credentials credentials.rows_hash
end

When /^I (?:|log in with my credentials|am logged in)$/ do
  visit login_path
  login_with filter_credentials @user_params
end

When /^I register an account with information$/ do |params|
  @user_params = filter_user_params params.rows_hash
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
  params.slice("email", "first_name", "last_name", "password", "password_confirmation")
end
def filter_credentials(credentials)
  credentials.slice("email", "password")
end

def login_with(credentials)
  credentials.each do |key, value|
    fill_in key, with: value
  end
  click_button "Sign in!"
end