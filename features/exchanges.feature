Feature: Managing exchanges
  In order to manage exchanges
  A user should have a nice command to do it

  Scenario: List exchanges
    Given I run "exchanges"
    Then I should see "Exchanges"
    And  I should see "Name"
    And  I should see "Kind"
    And  I should see "Durable"
    And  I should see "Delete"
    And  I should see "amq.fanout"
    And  I should see "Fanout"
    And  I should see "Direct"
    And  I should see "Topic"
