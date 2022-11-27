Feature: manage rental request
  As a user who has posted a listing on the platform
  In order to manage the requests that come through
  I want to be able to approve or decline a request

  Background: user is logged in and there are listings
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |cat@gmail.com |Cat    |W     |123 |
    And I have the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|paypal|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true  |
    And "Frankie Valli" has the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time          |return_time            |
      |2022-11-15 1:00:00 UTC|2022-11-20 00:00:00 UTC|

  Scenario: user approves a request made on their listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    And I click on the listing for "Dyson V11 Torque Drive"
    And I press "Approve"
    Then I should see the status of this request as "approved"

  Scenario: user declines a request made on their listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    And I click on the listing for "Dyson V11 Torque Drive"
    And I press "Decline"
    Then I should see the status of this request as "declined"