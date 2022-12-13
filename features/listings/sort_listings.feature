Feature: display listings filtered by item categories, payment type, rental time periods
    As a user who is looking to browse current item listings
    So that I can quickly find the items that interest me
    I want to sort item listings based on price or recency

    Background: user is logged in and there are listings
        Given the following users exist
            |email             |first_name |last_name |password    |phone|
            |frankie@columbia.edu |Frankie    |Valli     |password123 |1234567890|
            |bob@columbia.edu     |Bob        |Wu        |password123 |1234567891|
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |phone|
            |cat@columbia.edu     |Cat        |Wu        |password123 |1234567892|
        And I have the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|paypal|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |tools        |true  |
            |Bunny                 |a stuffed animal           |EC              |5.00|karma   |hour    |13.00  |school       |true  |
            |Penguin               |a stuffed animal           |EC              |5.00|karma   |hour    |1.00   |technology   |true  |
            |Cow                   |a stuffed animal           |EC              |5.00|dollars |hour    |3.00   |tools        |true  |
            |Cat                   |a stuffed animal           |EC              |5.00|dollars |hour    |143.00 |technology   |true  |
            |Dog                   |a stuffed animal           |EC              |5.00|dollars |hour    |13.00  |school       |true  |
            |Bull                  |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |day     |12.50  |tools        |true  |
            |Fish                  |a stuffed animal           |EC              |5.00|karma   |day     |13.00  |school       |true  |
            |Kitten                |a stuffed animal           |EC              |5.00|karma   |day     |153.00 |technology   |true  |
            |Bat                   |a stuffed animal           |EC              |5.00|dollars |day     |163.00 |tools        |true  |
            |Doraemon              |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |technology   |true  |
            |Pikachu               |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |school       |true  |
            |Goldfish              |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |week    |12.50  |tools        |true  |
            |Bear                  |a stuffed animal           |EC              |5.00|karma   |week    |13.00  |school       |true  |
            |Bird                  |a stuffed animal           |EC              |5.00|karma   |week    |183.00 |technology   |true  |
            |Seabear               |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |tools        |true  |
            |Seabunny              |a stuffed animal           |EC              |5.00|dollars |week    |123.00 |technology   |true  |
            |Seapenguin            |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |school       |true  |
        And "Frankie Valli" has the following review for "Dyson V11 Torque Drive"
            |review           |rating|
            |Nice vacuum!     |5     |
        And "Frankie Valli" has the following review for "Bunny"
            |review           |rating|
            |Cute bunny!!     |3     |
        And "Bob Wu" has the following review for "Bunny"
            |review           |rating|
            |not bad          |3     |

    @javascript
    Scenario: Sort listings in non-descending price order
        Given I am on the listings page
        When I sort the listings by "Sort Price High to Low"
        Then I should see "Bird" before "Kitten"

    @javascript
    Scenario: Sort listings in descending price order
        Given I am on the listings page
        When I sort the listings by "Sort Price Low to High"
        Then I should see "Kitten" before "Bird"

    @javascript
    Scenario: Sort listings from newest to oldest
        Given I am on the listings page
        When I sort the listings by "Sort by Newest"
        Then I should see "Dyson V11 Torque Drive" before "Bat"

    @javascript
    Scenario: Sort listings from oldest to newest
        Given I am on the listings page
        When I sort the listings by "Sort by Oldest"
        Then I should see "Bunny" before "Dyson V11 Torque Drive"

    @javascript
    Scenario: Sort listings in descending rating order
        Given I am on the listings page
        When I sort the listings by "Sort by Highest Rating"
        Then I should see "Bunny" before "Dyson V11 Torque Drive"