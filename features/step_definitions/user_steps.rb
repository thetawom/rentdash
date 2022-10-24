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

Then /^I should (?:|still )be on the login page$/ do
  expect(URI.parse(current_url).path).to eq(login_path)
end


def filter_user_params(params)
  params.slice("email", "first_name", "last_name", "password")
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