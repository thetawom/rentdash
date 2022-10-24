Feature: user logout
  As an avid user of the platform
  In order to keep my account and information secure
  I want to log out of my account after I am done browsing

  Background: registered user
    Given I am a registered user with credentials
      |email|uni1234@columbia.edu|
      |password|password123      |
    And I log in with my credentials

  Scenario: user logs out
    When I press "Sign out"
    Then I should be on the login page