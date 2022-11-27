Feature: display listings filtered by item categories, payment type, rental time periods
    As a user who is looking to browse current item listings
    So that I can quickly find the items that interest me
    I want to see item listings that fit my criteria

    Background: user is logged in and there are listings
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |
        And I have the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|venmo|paypal|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |tools        |true |true  |
            |Bunny                 |a stuffed animal           |EC              |5.00|karma   |hour    |13.00  |school       |true |false |
            |Penguin               |a stuffed animal           |EC              |5.00|karma   |hour    |13.00  |technology   |true |true  |
            |Cow                   |a stuffed animal           |EC              |5.00|dollars |hour    |13.00  |tools        |false |true  |
            |Capybara              |a stuffed animal           |EC              |5.00|dollars |hour    |13.00  |technology   |false |true |
            |Dog                   |a stuffed animal           |EC              |5.00|dollars |hour    |13.00  |school       |true |true  |
            |Bull                  |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |day     |12.50  |tools        |false|true  |
            |Fish                  |a stuffed animal           |EC              |5.00|karma   |day     |13.00  |school       |true |false |
            |Kitten                |a stuffed animal           |EC              |5.00|karma   |day     |13.00  |technology   |true |true  |
            |Bat                   |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |tools        |false|true  |
            |Doraemon              |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |technology   |true |true  |
            |Pikachu               |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |school       |true |false |
            |Goldfish              |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |week    |12.50  |tools        |false|true  |
            |Bear                  |a stuffed animal           |EC              |5.00|karma   |week    |13.00  |school       |true |true  |
            |Bird                  |a stuffed animal           |EC              |5.00|karma   |week    |13.00  |technology   |true |true  |
            |Seabear               |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |tools        |false|true  |
            |Seabunny              |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |technology   |true |true  |
            |Seapenguin            |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |school       |false|true  |

    @javascript
    Scenario: restrict to item listings with "dollar" currency, "day" time units, "tools" and "technology" item categories
        Given I am on the listings page
        When I check the following fee units: dollars
        And I uncheck the following fee units: karma
        And I check the following fee times: day
        And I uncheck the following fee times: hour, week
        And I check the following item categories: tools, technology
        And I uncheck the following item categories: school, cleaning, clothing, books
        Then I should see the following listings: Doraemon, Bat
        And I should not see the following listings: Dyson V11 Torque Drive, Bunny, Penguin, Cow, Capybara, Dog, Bull, Fish, Kitten, Pikachu, Goldfish, Bear, Bird, Seabear, Seabunny, Seapenguin