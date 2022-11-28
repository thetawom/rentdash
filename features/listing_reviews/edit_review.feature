Feature: edit review
  As a user who has added a review for an item
  I want to edit the review

  Background: these are the registered users
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
      |ethan@gmail.com   |Ethan      |Wu        |123         |
    Given I am a logged in user with information
      |email         |first_name |last_name |password    |
      |cat@gmail.com |Cat        |W         |123         |
    And "Frankie Valli" has the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|paypal|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Wien Hall       |1.03|karma   |hour    |12.50  |true  |
    And I have the following review for "Dyson V11 Torque Drive"
      |review           |rating|
      |Amazing vacuum!  |5     |
    And "Ethan Wu" has the following review for "Dyson V11 Torque Drive"
      |review                    |rating|
      |It is a very nice vacuum. |5     |

  Scenario: user successfully edits a review for a specific listing
    Given I am on the listing page for "Dyson V11 Torque Drive"
    Then I should see "Amazing vacuum!"
    And I should see "5"
    When I follow "Edit"
    And I change the rating to "3"
    And I press "Update Review"
    Then I should see "3"

  Scenario: user unsuccessfully edits a review for a specific listing
    Given I am on the listing page for "Dyson V11 Torque Drive"
    Then I should see "Amazing vacuum!"
    And I should see "5"
    When I follow "Edit"
    And I change the rating to ""
    And I press "Update Review"
    Then I should see "can't be blank"

  Scenario: user tries to delete a review made by another user
    Given I am on the listing page for "Dyson V11 Torque Drive"
    Then I should not see an Edit button for "Ethan Wu's" review