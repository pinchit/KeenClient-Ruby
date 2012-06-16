# Language: en
Feature: RedisHandler
  In order to make fewer than n HTTP connections for n events
  As a developer
  I want to be able to batch up events in Redis and send them to Keen all at once.

  Scenario Outline: Batch up n events
    Given I've posted <n> events
    When I process the queue
    Then the response should be <n> happy smiles
    And the queue should then be empty.

    Examples:
      |n    | 
      |1    | 
      |100  | 
      |99   | 
      |1000 | 
      |999  | 
