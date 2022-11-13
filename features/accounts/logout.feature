Feature: user logout
  As an avid user of the platform
  In order to keep my account and information secure
  I want to log out of my account after I am done browsing

  Background: registered user
    Given I am a registered user with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |

  Scenario: user logs out
    Given I am logged in
    Then I should see "Sign out"
    When I press "Sign out"
    Then I should be on the login page