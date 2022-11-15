Feature: edit rental request
  As a user who has made a rental request on the platform
  In order to edit the request if I made a mistake or the details changed
  I want to edit the request on the platform

  Background: user is logged in and there are listings
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |cat@gmail.com |Cat    |W     |123 |
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |
    And I have the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |
      |2022-11-15 1:00:00 UTC|2022-11-20 00:00:00 UTC|
    
  Scenario: user navigates to the edit rental request page from the details page
    Given I am on the listings page
    When I follow "My Rentals"
    Then I should be on my rentals page
    And I should see "Dyson V11 Torque Drive"
    And I follow "Details"
    And I follow "Edit"
    When I fill in "Pick-up Time" with "2022-11-16 01:00:00 UTC"
    And I press "Update Rental Request"
    Then I should see that the request for "Dyson V11 Torque Drive" was successfully updated