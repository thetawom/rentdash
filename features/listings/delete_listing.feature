Feature: delete listing
  As a user who has listed an item on the platform
  In order to remove the item if it is no longer available for rental
  I want to delete the listing on the platform

  Background: user is logged in and there are listings
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    And I have the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|venmo|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |tools        |true |

  Scenario: delete the listing
    Given I am on the listings page
    And I click on the listing for "Dyson V11 Torque Drive"
    And I press "Delete"
    Then I should not see a listing for "Dyson V11 Torque Drive"

  Scenario: user tries to delete listing owned by another user
    Given the following users exist
      |email             |first_name |last_name |password    |
      |joe@gmail.com     |Joe        |Long      |password123 |
    And "Joe Long" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|paypal|
      |Mirrored Swim Goggles |                           |East Campus     |0.00|dollars |hour    |9.00   |tools        |true  |
    When I go to the listing page for "Mirrored Swim Goggles"
    Then I should not see "Delete"