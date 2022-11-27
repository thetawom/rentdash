Feature: edit rental request
  As a user who has made a rental request on the platform
  In order to edit the request if I made a mistake or want to change the details
  I want to edit my rental request on the platform

  Background: user has a pending rental request on a listing
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true|
    Given I am a logged in user with information
      |email         |first_name |last_name |password    |
      |cat@gmail.com |Cat        |W         |123         |
    And I have the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |payment_method|
      |2022-11-15 1:00:00 UTC |2022-11-20 00:00:00 UTC|cash          |
    
  Scenario: user successfully edits request date from my rentals page
    Given I am on the listings page
    When I follow "My Rentals"
    Then I should be on my rentals page
    And I should see "Dyson V11 Torque Drive"
    When I follow "Details"
    And I follow "Edit"
    And I fill in "Pick-up Time" with "2022-11-16 01:00:00 UTC"
    And I press "Update Rental Request"
    Then I should be on the rental requests page for "Dyson V11 Torque Drive"
    And I should see that the request for "Dyson V11 Torque Drive" was successfully updated
    And I should see "Wed 11/16/22 1:00 AM"

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