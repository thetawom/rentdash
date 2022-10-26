Feature: user login
  As an avid user of the platform
  In order to access rental offerings or post my own listings
  I want to log in to my account on the platform

  Background: registered user
    Given I am a registered user with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |

  Scenario: user logs in with correct credentials
    When I log in with my credentials
    Then I should see "Sign out"

  Scenario: user logs in with incorrect credentials
    When I log in with credentials
      |email|uni1234@columbia.edu|
      |password|password321      |
    Then I should still be on the login page
    And I should see "Username or password is incorrect"