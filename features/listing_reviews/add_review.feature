Feature: add review
  As a user who has rented something out before on the platform
  I want to add a review for this item

  Background: these are the registered users
    Given the following users exist
      |email             |first_name |last_name |password    |phone|
      |frankie@columbia.edu |Frankie    |Valli     |password123 |1234567890|
    Given I am a logged in user with information
      |email         |first_name |last_name |password    |phone|
      |cat@columbia.edu |Cat        |W         |123         |1234567891|
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|paypal|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true  |

  Scenario: user successfully adds a review for a specific listing
    Given I am on the listing page for "Dyson V11 Torque Drive"
    Then I should see "Add review"
    When I follow "Add review"
    Then I should be on the new review page for "Dyson V11 Torque Drive"
    When I add a new review with information
      |review           |rating|
      |Amazing vacuum!  |5     |
    Then I should be on the listing page for "Dyson V11 Torque Drive"
    And I should see "Amazing vacuum!"
    And I should see "5"

  Scenario: user adds a review without filling in all required fields
    Given I am on the listing page for "Dyson V11 Torque Drive"
    Then I should see "Add review"
    When I follow "Add review"
    Then I should be on the new review page for "Dyson V11 Torque Drive"
    When I add a new review with information
      |review           |
      |It was okay      |
    Then I should still be on the new review page for "Dyson V11 Torque Drive"
    And I should see "can't be blank"