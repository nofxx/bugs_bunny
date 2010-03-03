Feature: Debug RabbitMQ
  In order to restore mental sanity
  A user has a tool to play with rabbitmq

  Scenario: Without params
    Given I run ""
    Then I should see "Bugs Bunny"
    And  I should see "Bugs Bunny"
    And  I should see "Usage"

