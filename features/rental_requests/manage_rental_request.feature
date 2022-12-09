Feature: manage rental request
  As a user who has posted a listing on the platform
  In order to manage the requests that come through
  I want to be able to approve or decline a request

  Background: user is logged in and there are listings
    Given the following users exist
      |email             |first_name |last_name |password    |
      |frankie@gmail.com |Frankie    |Valli     |password123 |
      |ethan@gmail.com   |Ethan      |Wu        |123         |
      |lucy@gmail.com    |Lucy       |Wu        |123         |
    Given I am a logged in user with information
      |email             |first_name |last_name |password    |
      |cat@gmail.com     |Cat        |Wu        |123         |
    And I have the following listings
      |name                  |description                |pick_up_location|fee |fee_unit|fee_time|deposit|paypal|
      |Dyson V11 Torque Drive|an excellent vacuum cleaner|Broadway Hall   |1.03|karma   |hour    |12.50  |true  |
      |Drum                  |a drum                     |Wien Hall       |2   |karma   |day     |5      |true  |
      |Dog Toy               |squeaky dog toy            |Wien Hall       |3   |karma   |week    |1      |true  |
    And "Frankie Valli" has the following rental requests for "Dyson V11 Torque Drive"
      |pick_up_time          |return_time            |payment_method|
      |2030-11-15 1:00:00 UTC|2030-11-20 00:00:00 UTC|paypal        |
    And "Ethan Wu" has the following rental requests for "Drum"
      |pick_up_time          |return_time            |payment_method|
      |2030-11-10 1:00:00 UTC|2030-11-11 00:00:00 UTC|paypal        |
    And "Lucy Wu" has the following rental requests for "Dog Toy"
      |pick_up_time          |return_time            |payment_method|
      |2030-11-05 1:00:00 UTC|2030-11-19 00:00:00 UTC|paypal        |

  Scenario: user approves a request made on their hourly listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    And I click on the listing for "Dyson V11 Torque Drive"
    And I press "Approve"
    Then I should see the status of this request as "approved"
    And I should see "Karma: 122"

  Scenario: user approves a request made on their daily listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Drum"
    And I click on the listing for "Drum"
    And I press "Approve"
    Then I should see the status of this request as "approved"
    And I should see "Karma: 2"

  Scenario: user approves a request made on their weekly listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dog Toy"
    And I click on the listing for "Dog Toy"
    And I press "Approve"
    Then I should see the status of this request as "approved"
    And I should see "Karma: 6"

  Scenario: user declines a request made on their listing
    Given I am on the listings page
    When I follow "My Listings"
    Then I should be on my listings page
    And I should see "Dyson V11 Torque Drive"
    And I click on the listing for "Dyson V11 Torque Drive"
    And I press "Decline"
    Then I should see the status of this request as "declined"