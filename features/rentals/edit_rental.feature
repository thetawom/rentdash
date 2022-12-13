Feature: edit rental
  As a user who has a listing currently being rented out on the platform
  I want to edit the details for a specific rental

  Background: user is logged in and there are listings
    Given the following users exist
      |email                |first_name |last_name |password    |phone     |
      |frankie@columbia.edu |Frankie    |Valli     |password123 |1234567890|
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |phone     |
      |cat@columbia.edu  |Cat        |W         |123         |1234567891|
    And I have the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true|
    And "Frankie Valli" has the following approved rental requests for "Dyson V11 Torque Drive"
      |pick_up_time          |return_time            |payment_method|
      |2030-11-15 1:00:00 UTC|2030-11-20 00:00:00 UTC|cash          |

  Scenario: user successfully edits the status for an approved request from my rentals page
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    When I follow "Details" for "Dyson V11 Torque Drive"
    And I follow "Edit Rental Details"
    And I change the status to "Ongoing"
    And I press "Edit Rental"
    Then I should see that updating "Dyson V11 Torque Drive" was successful

  Scenario: user unsuccessfully edits the pick-up time for an approved request from my rentals page
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    When I follow "Details" for "Dyson V11 Torque Drive"
    And I follow "Edit Rental Details"
    And I change the pick-up time
    And I press "Edit Rental"
    Then I should see that updating "Dyson V11 Torque Drive" was unsuccessful