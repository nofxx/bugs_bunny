Feature: Managing queues
  In order to manage queues
  A user should have a nice command to do it

  Scenario: List queues
    Given a queue "crucification" with 10 messages
    When I run "queue crucification"
    Then I should see "Listing"



