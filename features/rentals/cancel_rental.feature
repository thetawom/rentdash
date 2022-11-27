Feature: cancel rental
  As a user who currently has a scheduled rental on the platform
  I want to cancel my scheduled rental

  Background: these are the registered users
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |cat@gmail.com     |Cat        |Wu        |123         |
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|venmo|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true |
      |Book|a book|Furnald Hall       |3.50|dollars   |day    |1.50  |true|
    And "Cat Wu" has the following approved rental requests for "Dyson V11 Torque Drive"
      |pick_up_time           |return_time            |payment_method|
      |2030-10-28 00:00:00 UTC|2030-10-29 00:00:00 UTC|venmo         |

  Scenario: user cancels a scheduled rental
    Given I am on the listings page
    When I follow "My Rentals"
    Then I should be on my rentals page
    And I should see "Dyson V11 Torque Drive" in upcoming-rentals
    And I follow "Details" for "Dyson V11 Torque Drive"
    Then I should be on my rental page for "Dyson V11 Torque Drive"
    And I press "Cancel Rental"
    Then I should see that the rental is cancelled