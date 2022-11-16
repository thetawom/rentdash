Feature: delete rental request
  As a user who has submitted a rental request on the platform
  In order to remove the request if I no longer want the item
  I want to delete my request on the platform

  Background: user is logged in and there are listings
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
      |ethan@gmail.com   |Ethan      |Wu        |123         |
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |cat@gmail.com |Cat    |W     |123 |
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |
    And I have the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |
      |2022-11-15 1:00:00 UTC|2022-11-20 00:00:00 UTC|
    And "Ethan Wu" has the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |
      |2022-12-15 1:00:00 UTC|2022-12-22 00:00:00 UTC|

  Scenario: delete the rental request
    Given I am on the listings page
    And I follow "My Rentals"
    Then I should see "Dyson V11 Torque Drive"
    And I follow "Details"
    And I press "Cancel"
    Then I should be on the rental requests page for "Dyson V11 Torque Drive"

  Scenario: user tries to delete a request made by another user
    Given I am on the listings page
    Then I should see "Dyson V11 Torque Drive"
    And I follow "Details"
    Then I should not see a request from "Ethan Wu"
