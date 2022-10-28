Feature: add rental request
  As a user with a need for an item listed on the website
  In order to rent the specified item
  I want to add a rental request for that specified item

    Background: these are the registered users
        Given the following users exist
            |email             |first_name |last_name |password    |
            |nathan@gmail.com  |Nathan     |Nguyen    |asdfjkl;    |
        
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |

        Given "Nathan Nguyen" has the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |
        
    Scenario: user navigates to the new rental request page for a specific listing
        Given I am on the listing page for "Dyson V11 Torque Drive"
        Then I should see "Rent This"
        When I follow "Rent This"
        Then I should be on the new rental request page for "Dyson V11 Torque Drive"
    
    Scenario: user successfully adds a new rental request
        Given I am on the new rental request page for "Dyson V11 Torque Drive"
        When I add a new rental request with information
            |pick_up_date                  |return_date                |
            |2022-10-28 00:00:00 UTC|2022-10-29 00:00:00 UTC|
        Then I should be on the listing page for "Dyson V11 Torque Drive"
        When I follow "My Rentals"
        Then I should see "2022-10-28 00:00:00 UTC"
        And I should see "2022-10-29 00:00:00 UTC"
        And I should see "Dyson V11 Torque Drive"
    
    Scenario: user adds a rental request without filling in all required fields
        Given I am on the new rental request page for "Dyson V11 Torque Drive"
        When I add a new rental request with information
            |pick_up_date                  |
            |2022-10-28 00:00:00 UTC|
        Then I should still be on the new rental request page for "Dyson V11 Torque Drive"
    
    