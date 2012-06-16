# Language: en
Feature: RedisHandler
  In order to make fewer than n HTTP connections for n events
  As a developer
  I want to be able to batch up events in Redis and send them to Keen all at once.

  Scenario Outline: Send a bunch of events.
    Given a Keen Client using Redis
    When I post <n> events
    And I process the queue
    Then the response from Keen should be <n> happy smiles
    And the queue should be empty.

    Examples:
      |n    | 
      |1    | 
      |100  | 
      |99   | 
      |1000 | 
      |999  | 

  Scenario Outline: Add Events to Redis queue
    Given a Keen Client using Redis
    When I post <n> events
    Then the size of the Redis queue should have gone up by <n>.

    Examples:
      |n    | 
      |1    | 
      |100  | 
      |99   | 
      |1000 | 
      |999  | 
