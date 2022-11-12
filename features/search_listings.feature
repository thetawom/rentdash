Feature: search through all listings by listing name
    As a user who is looking to browse current item listings
    So that I can quickly find the items that interest me
    I want to search for item listings by their name

    Background: user is logged in and there are listings
        Given I am a logged in user with information
            |email             |first_name |last_name |password    |
            |frankie@gmail.com |Frankie    |Valli     |password123 |
        And I have the following listings
            |name        |description      |pick_up_location|fee |fee_unit|fee_time|deposit|item_category|
            |Bunny       |a stuffed animal |EC              |5.00|karma   |hour    |13.00  |school       |
            |Penguin     |a stuffed animal |EC              |5.00|karma   |hour    |1.00   |technology   |
            |Cow         |a stuffed animal |EC              |5.00|dollars |hour    |3.00   |tools        |
    
    Scenario: Search for listings that contain the substring bunny
        Given I am on the listings page
        Then I should see the following listings: Bunny
        When I fill in "search" with "bunny"
        And I press "Search"
        Then I should see the following listings: Bunny
        And I should not see the following listings: Penguin, Cow

        