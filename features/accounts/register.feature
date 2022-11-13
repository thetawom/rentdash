Feature: user registration
  As an aspiring user of the platform
  In order to access rental offerings or post my own listings
  I want to register an account on the platform

  Scenario: user successfully registers an account
    When I register an account with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    Then I should see "Sign out"
    When I press "Sign out"
    And I log in with my credentials
    Then I should see "Sign out"

  Scenario: user attempts to register with a taken email
    Given I am a registered user with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    When I register an account with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    Then I should still be on the registration page

  Scenario: user attempts to register with passwords that are not the same
    When I register an account with information
      |email             |first_name |last_name |password    |password_confirmation|
      |frankie@gmail.com |Frankie    |Valli     |password123 |password456          |
    Then I should still be on the registration page

  Scenario: user attempts to register without filling in all the required fields
    When I register an account with information
      |email             |first_name |password    |
      |frankie@gmail.com |Frankie    |password123 |
    Then I should still be on the registration page