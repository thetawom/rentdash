Feature: view rental
  As a user who is renting an item
  I want to view the details for the rental

    Background: these are the registered users
      Given the following users exist
        |email             |first_name |last_name |password    |
        |frankie@gmail.com |Frankie    |Valli     |password123 |
      Given I am a logged in user with information
        |email             |first_name |last_name |password    |
        |cat@gmail.com     |Cat        |Wu        |123         |
      And "Frankie Valli" has the following listings
        |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|
        |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |
        |Book|a book|Furnald Hall       |3.50|dollars   |day    |1.50  |
      And I have the following approved rental requests for "Dyson V11 Torque Drive"
        |pick_up_time           |return_time            |
        |2022-10-28 00:00:00 UTC|2022-10-29 00:00:00 UTC|
      And I have the following declined rental requests for "Book"
        |pick_up_time           |return_time            |
        |2022-10-28 00:00:00 UTC|2022-10-29 00:00:00 UTC|

    Scenario: user sees their own rentals
      Given I am on the listings page
      When I follow "My Rentals"
      Then I should be on my rentals page
      And I should not see "Book" in upcoming-rentals
      And I should see "Dyson V11 Torque Drive" in upcoming-rentals
      And I follow "Details" for "Dyson V11 Torque Drive"
      Then I should be on my rental page for "Dyson V11 Torque Drive"