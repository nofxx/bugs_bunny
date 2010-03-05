Feature: Managing queues
  In order to manage queues
  A user should have a nice command to do it

  Scenario: Creating queues
    Given I have no queues
    When I run "queues new todo"
    Then I should have 1 queues
    When I run "queues"
    Then I should see "todo"
    And  I should see "0"

  Scenario: Show queues
    Given a queue "crucification" with 3 messages
    When I run "queue crucification"
    Then I should see "About crucification"
    And  I should see "3 messages, 0 consumers"

  Scenario: List queues
    Given I run "queues"
    Then I should see "Queues"
    And  I should see "Name"
    And  I should see "todo"
    And  I should see "(D)"
    And  I should see "crucification"
    And  I should see "Msgs"
    And  I should see "3"
    And  I should see "Users"
    And  I should see "0"

  Scenario: Add to queue
    Given a queue "works"
    When I run "queue works add bugsbunny"
    And  I run "queue works"
    Then I should see "About works"
    And  I should see "1 message"
    When I run "queue works add bunny"
    And  I run "queue works"
    Then I should see "About works"
    And  I should see "2 messages"

  Scenario: Pop from queue
    When I run "queue works pop"
    Then I should see "Pop"
    And  I should see "bugsbunny"
    And  I run "queue works"
    Then I should see "About works"
    And  I should see "1 messages"
    When I run "queue works pop"
    And  I run "queue works"
    And  I should see "0 messages"

  Scenario: List all messages
    When I run "queue works add rock"
    And  I run "queue works add roll"
    When I run "queue works list"
    Then I should see "QUEUE 1"
    And  I should see "rock"
    And  I should see "Consumer: works"
    And  I should see "Exchange:"
    And  I should see "QUEUE 2"
    And  I should see "roll"
    And  I should see "Mode 1"

  Scenario: Purging queue
    When I run "queue works add more"
    Then I run "queue works purge"
    And  I run "queue works"
    And  I should see "0 messages"
    When I run "queue crucification"
    Then I should see "3 messages"

  Scenario: Purging queues
    When I run "queue works add moreone"
    And  I run "queue works"
    And  I should see "1 message"
    Then I run "queues purge"
    And  I run "queue works"
    And  I should see "0 messages"
    When I run "queue crucification"
    Then I should see "0 messages"

  Scenario: JSON queues
    When I run 'queue works add "{\"foo\": 2}"'
    And  I run "queue works list -m json"
    Then I should see "QUEUE 1"
    And  I should see "works"
    And  I should see "Body"
