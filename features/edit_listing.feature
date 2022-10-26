Feature: edit listing
  As a user who has added a listing for my item
  I want to edit the listing

  Background: registered user
    Given I am a registered user with information
      |email|uni1234@columbia.edu|
      |first_name|Frankie        |
      |last_name |Valli          |
      |password|password123      |
    And I log in with my credentials
    Given the following listings exist
      |name|description|pick_up_location|fee|fee_unit|fee_time|deposit|
      |Vacuum Cleaner|an excellent vacuum cleaner|Wien Hall|1.03|karma|hour|12.50|

  Scenario: update pick-up location for the listing
    Given I am on the listings page
    And I follow "More about Vacuum Cleaner"
    And I follow "Edit"
    And I fill in "Pick-up Location" with "Furnald Hall"
    And I press "Update Listing Info"
    Then the pick-up location of "Vacuum Cleaner" should be "Furnald Hall"