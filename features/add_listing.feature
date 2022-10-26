Feature: add listing
  As a user with an extra or unused item
  In order to rent it out to other users of the platform
  I want to add a listing for my item

  Background: registered user
    Given I am a registered user with information
      |email|uni1234@columbia.edu|
      |first_name|Frankie        |
      |last_name |Valli          |
      |password|password123      |
    And I log in with my credentials

  Scenario: user can navigate to the new listing form from listings page
    Given I am on the listings page
    Then I should see "Add new listing"
    When I follow "Add new listing"
    Then I should be on the new listing page

  Scenario: user successfully adds a new listing
    Given I am on the new listing page
    When I add a new listing with information
      |name|Dyson V11 Torque Drive Vacuum Cleaner|
      |description|an excellent vacuum cleaner   |
      |pick_up_location|Wien Hall                |
      |fee      |1.03                            |
      |fee_unit |Karma                           |
      |fee_time |Hour                            |
      |deposit  |12.50                           |
    Then I should be on the listings page
    And I should see a listing for "Dyson V11 Torque Drive Vacuum Cleaner"