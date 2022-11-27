Feature: submit rental request
    As a user with a need for an item listed on the website
    In order to rent the specified item
    I want to submit a rental request for that specified item

    Background: these are the registered users
        Given the following users exist
            |email             |first_name |last_name |password    |
            |nathan@gmail.com  |Nathan     |Nguyen    |asdfjkl;    |
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |
        Given "Nathan Nguyen" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|cash|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true|

    Scenario: user navigates to the new rental request page for a specific listing
        Given I am on the listing page for "Dyson V11 Torque Drive"
        Then I should see "Rent this!"
        When I follow "Rent this!"
        Then I should be on the new rental request page for "Dyson V11 Torque Drive"
        When I submit a new rental request with information
            |pick_up_time           |return_time            |payment_method|
            |2022-10-28 00:00:00 UTC|2022-10-29 00:00:00 UTC|cash          |
        Then I should be on the rental requests page for "Dyson V11 Torque Drive"
        And I should see "Fri 10/28/22 12:00 AM"
        And I should see "Sat 10/29/22 12:00 AM"
        When I follow "My Rentals"
        Then I should see "Dyson V11 Torque Drive"
        And I should see "Pick-up 10/28 12:00 AM"
        And I should see "Due by 10/29 12:00 AM"

    Scenario: user adds a rental request without filling in all required fields
        Given I am on the new rental request page for "Dyson V11 Torque Drive"
        When I submit a new rental request with information
            |pick_up_time           |
            |2022-10-28 00:00:00 UTC|
        Then I should still be on the new rental request page for "Dyson V11 Torque Drive"

    