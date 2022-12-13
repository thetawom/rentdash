Feature: edit rental request
  As a user who has made a rental request on the platform
  In order to edit the request if I made a mistake or want to change the details
  I want to edit my rental request on the platform

  Background: user has a pending rental request on a listing
    Given the following users exist
      |email                |first_name |last_name |password    |phone     |
      |frankie@columbia.edu |Frankie    |Valli     |password123 |1234567890|
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true|
    Given I am a logged in user with information
      |email            |first_name |last_name |password    |phone     |
      |cat@columbia.edu |Cat        |W         |123         |1234567891|
    And I have the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |payment_method|
      |2030-11-15 1:00:00 UTC |2030-11-20 00:00:00 UTC|cash          |
    And "Frankie Valli" has 500 karma
    And "Cat W" has 500 karma
    
  Scenario: user successfully edits request date from my rentals page
    Given I am on the listings page
    When I follow "My Rentals"
    Then I should be on my rentals page
    And I should see "Dyson V11 Torque Drive"
    When I follow "Details"
    And I follow "Edit"
    And I fill in "Pick-up Time" with "2030-11-16 01:00:00 UTC"
    And I press "Update Rental Request"
    Then I should be on the rental requests page for "Dyson V11 Torque Drive"
    And I should see that the request for "Dyson V11 Torque Drive" was successfully updated
    And I should see "Sat 11/16/30 1:00 AM"

  Scenario: user edits rental request date to see the estimated cost
    Given I am on the listings page
    When I follow "My Rentals"
    Then I should be on my rentals page
    And I should see "Dyson V11 Torque Drive"
    When I follow "Details"
    And I follow "Edit"
    And I fill in "Return Time" with "2030-11-16 01:00:00 UTC"
    And I press "Calculate Estimated Cost"
    Then I should see "Estimated Cost: 24.72 karma total and $12.5 deposit"

  Scenario: user tries to edit the request with an invalid date
    Given I am on the rental requests page for "Dyson V11 Torque Drive"
    When I follow "Edit"
    Then I should be on the edit request page for "Dyson V11 Torque Drive"
    When I fill in "Pick-up Time" with ""
    And I press "Update Rental Request"
    Then I should still be on the edit request page for "Dyson V11 Torque Drive"

  Scenario: user tries to edit a request that is already approved
    Given my rental request for "Dyson V11 Torque Drive" is approved
    When I go to the rental requests page for "Dyson V11 Torque Drive"
    Then I should not see "Edit"
    When I go to the edit request page for "Dyson V11 Torque Drive"
    Then I should be on the rental requests page for "Dyson V11 Torque Drive"
    And I should see "You can no longer make any changes to this request."