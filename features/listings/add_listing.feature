Feature: add listing
  As a user with an extra or unused item
  In order to rent it out to other users of the platform
  I want to add a listing for my item

  Background: user is logged in
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |

  Scenario: user successfully adds a new listing
    Given I am on the listings page
    Then I should see "Add new listing"
    When I follow "Add new listing"
    Then I should be on the new listing page
    When I add a new listing with information
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|Karma   |Hour    |12.50  |Tools        |
    Then I should be on the listing page for "Dyson V11 Torque Drive"
    When I go to the listings page
    Then I should see a listing for "Dyson V11 Torque Drive"

  Scenario: user adds a listing without filling in all required fields
    Given I am on the new listing page
    When I add a new listing with information
      |name                  |
      |Dyson V11 Torque Drive|
    Then I should still be on the new listing page

  Scenario: user adds a listing with invalid values
    Given I am on the new listing page
    When I add a new listing with information
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|Karma   |Hour    |-2     |Tools        |
    Then I should still be on the new listing page

  Scenario: user views their own listings
    Given I am on the listings page
    Then I should see all my listings