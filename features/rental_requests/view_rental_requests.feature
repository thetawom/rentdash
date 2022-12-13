Feature: view rental requests
  As a user with an item listing on the website
  In order to rent out the specified item
  I want to view all the rental requests for that specific item

    Background: these are the registered users
        Given the following users exist
            |email                |first_name |last_name |password    |phone     |
            |frankie@columbia.edu |Frankie    |Valli     |password123 |1234567890|
            |cat@columbia.edu     |Cat        |Wu        |123         |1234567891|
        And "Frankie Valli" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|paypal|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true  |
        And "Cat Wu" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|venmo|
            |Cape Cod Potato Chips |savory and delicious       |Furnald Hall    |5   |dollars |week    |1.00   |true |

        Given I am a logged in user with information
            |email                |first_name |last_name |password    |phone     |
            |nathan@columbia.edu  |Nathan     |Nguyen    |asdfjkl;    |1234567892|
        And I have the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
            |Mr. Bunny             |the best bunny alive       |East Campus     |1   |karma   |hour    |13.50  |true|

        Given I have the following rental requests for "Dyson V11 Torque Drive"
            |pick_up_time           |return_time            |payment_method|
            |2030-10-28 00:00:00 UTC|2030-10-29 00:00:00 UTC|cash          |
        And I have the following rental requests for "Cape Cod Potato Chips"
            |pick_up_time           |return_time            |payment_method|
            |2030-11-28 00:00:00 UTC|2030-11-29 00:00:00 UTC|cash          |
        And "Frankie Valli" has the following rental requests for "Mr. Bunny"
            |pick_up_time           |return_time            |payment_method|
            |2030-12-28 00:00:00 UTC|2031-01-29 00:00:00 UTC|cash          |
        And "Cat Wu" has the following rental requests for "Dyson V11 Torque Drive"
            |pick_up_time           |return_time            |payment_method|
            |2030-11-28 10:00:00 UTC|2030-12-20 00:00:00 UTC|cash          |
        
    Scenario: user can see all of their rental requests under my rentals
        Given I am on the listings page
        When I follow "My Rentals"
        Then I should be on my rentals page
        And I should see "Dyson V11 Torque Drive"
        And I should see "Pick-up 10/28 12:00 AM"
        And I should see "Due by 10/29 12:00 AM"
        And I should see "Cape Cod Potato Chips"
        And I should see "Pick-up 11/28 12:00 AM"
        And I should see "Due by 11/29 12:00 AM"

    Scenario: user can see their rental requests for a specific listing
        Given I am on the listing page for "Dyson V11 Torque Drive"
        When I follow "View Requests"
        Then I should see "Mon 10/28/30 12:00 AM"
        And I should see "Tue 10/29/30 12:00 AM"
    
    Scenario: user can see rental requests for their own listing
        Given I am on the listing page for "Mr. Bunny"
        When I follow "Manage Requests"
        Then I should see "Sat 12/28/30 12:00 AM"
        And I should see "Wed 01/29/31 12:00 AM"

    Scenario: user tries to look at another user's rental requests
        Given I am on the listings page
        When I go on Cat Wu's request for "Dyson V11 Torque Drive"
        Then I should be on my listings page
        