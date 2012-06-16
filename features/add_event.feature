# Language: en
Feature: AddEvent
  In order to send an event to Keen's servers
  As a developer
  I want to be able to post an event to the Keen Client as a Hash/Dictionary

  Scenario: Add Event to Redis queue
    Given a Keen Client using Redis
    When I post an event
    Then the size of the Redis queue should have gone up by one.

  Scenario: Send Event directly to Keen
    Given a Keen Client using Direct
    When I post an event
    Then the response from the server should be good.
