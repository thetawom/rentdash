Feature: submit rental request
    As a user with a need for an item listed on the website
    In order to rent the specified item
    I want to submit a rental request for that specified item

    Background: these are the registered users
        Given the following users exist
            |email             |first_name |last_name |password    |
            |nathan@gmail.com  |Nathan     |Nguyen    |asdfjkl;    |
            |lucy@gmail.com    |Lucy       |Wu        |password    |
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |
        Given "Nathan Nguyen" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |2   |dollars |hour    |12.50  |true|
        Given "Lucy Wu" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|venmo|
            |Laptop Charger        |laptop charger             |Broadway Hall   |1   |dollars |day     |6      |true |
            |Pan                   |it's a pan                 |Wien Hall       |5   |dollars |week    |2      |true |

    Scenario: user navigates to the new rental request page for a specific listing
        Given I am on the listing page for "Dyson V11 Torque Drive"
        Then I should see "Rent this!"
        When I follow "Rent this!"
        Then I should be on the new rental request page for "Dyson V11 Torque Drive"
        When I submit a new rental request with information
            |pick_up_time           |return_time            |payment_method|
            |2030-10-28 00:00:00 UTC|2030-10-29 00:00:00 UTC|cash          |
        Then I should be on the rental requests page for "Dyson V11 Torque Drive"
        And I should see "Mon 10/28/30 12:00 AM"
        And I should see "Tue 10/29/30 12:00 AM"
        When I follow "My Rentals"
        Then I should see "Dyson V11 Torque Drive"
        And I should see "Pick-up 10/28 12:00 AM"
        And I should see "Due by 10/29 12:00 AM"

    Scenario: user checks to see what the estimated cost would be for an hourly rental
        Given I am on the listing page for "Dyson V11 Torque Drive"
        Then I should see "Rent this!"
        When I follow "Rent this!"
        Then I should be on the new rental request page for "Dyson V11 Torque Drive"
        When I calculate the cost for a new rental request with information
            |pick_up_time           |return_time            |payment_method|
            |2030-10-28 00:00:00 UTC|2030-10-28 02:00:00 UTC|cash          |
        Then I should see "Estimated Cost: 4.0 dollars total and $12.5 deposit"

    Scenario: user checks to see what the estimated cost would be for a daily rental
        Given I am on the listing page for "Laptop Charger"
        Then I should see "Rent this!"
        When I follow "Rent this!"
        Then I should be on the new rental request page for "Laptop Charger"
        When I calculate the cost for a new rental request with information
            |pick_up_time           |return_time            |payment_method|
            |2030-10-28 00:00:00 UTC|2030-10-30 00:00:00 UTC|venmo         |
        Then I should see "Estimated Cost: 2.0 dollars total and $6.0 deposit"

    Scenario: user checks to see what the estimated cost would be for a weekly rental
        Given I am on the listing page for "Pan"
        Then I should see "Rent this!"
        When I follow "Rent this!"
        Then I should be on the new rental request page for "Pan"
        When I calculate the cost for a new rental request with information
            |pick_up_time           |return_time            |payment_method|
            |2030-10-01 00:00:00 UTC|2030-10-30 00:00:00 UTC|venmo         |
        Then I should see "Estimated Cost: 25.0 dollars total and $2.0 deposit"

    Scenario: user adds a rental request without filling in all required fields
        Given I am on the new rental request page for "Dyson V11 Torque Drive"
        When I submit a new rental request with information
            |pick_up_time           |
            |2030-10-28 00:00:00 UTC|
        Then I should still be on the new rental request page for "Dyson V11 Torque Drive"

    