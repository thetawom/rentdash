Feature: search through all listings by listing name
    As a user who is looking to browse current item listings
    So that I can quickly find the items that interest me
    I want to search for item listings by their name

    Background: user is logged in and there are listings
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |
        And I have the following listings
            |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|
            |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |tools        |
            |Bunny                 |a stuffed animal           |EC              |5.00|karma   |hour    |13.00  |school       |
            |Penguin               |a stuffed animal           |EC              |5.00|karma   |hour    |1.00   |technology   |
            |Cow                   |a stuffed animal           |EC              |5.00|dollars |hour    |3.00   |tools        |
            |Cat                   |a stuffed animal           |EC              |5.00|dollars |hour    |143.00 |technology   |
            |Dog                   |a stuffed animal           |EC              |5.00|dollars |hour    |13.00  |school       |
            |Bull                  |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |day     |12.50  |tools        |
            |Fish                  |a stuffed animal           |EC              |5.00|karma   |day     |13.00  |school       |
            |Kitten                |a stuffed animal           |EC              |5.00|karma   |day     |153.00 |technology   |
            |Bat                   |a stuffed animal           |EC              |5.00|dollars |day     |163.00 |tools        |
            |Doraemon              |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |technology   |
            |Pikachu               |a stuffed animal           |EC              |5.00|dollars |day     |13.00  |school       |
            |Goldfish              |an excellent vacuum cleaner|Wien Hall       |1.03|karma   |week    |12.50  |tools        |
            |Bear                  |a stuffed animal           |EC              |5.00|karma   |week    |13.00  |school       |
            |Bird                  |a stuffed animal           |EC              |5.00|karma   |week    |183.00 |technology   |
            |Seabear               |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |tools        |
            |Seabunny              |a stuffed animal           |EC              |5.00|dollars |week    |123.00 |technology   |
            |Seapenguin            |a stuffed animal           |EC              |5.00|dollars |week    |13.00  |school       |
    
    Scenario: Search for listings that contain the substring bunny
        Given I am on the listings page
        When  I fill in "search" with "bunny"
        And I press "Search"
        Then I should see "Bunny"
        And I should see "Seabunny"