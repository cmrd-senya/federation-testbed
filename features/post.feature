Feature: Post messages
  As a user of diaspora federation
  I should be able to send messages to a diaspora pod
  And I should receive response
  # MK: I think response should be specified more precisely

  Background:
    Given an existing server
    And an existing user account at the testbed
    And an existing webfinger document
    And I make a hcard-request
    And I should receive a valid hcard document

  Scenario: sending a public message
    Given a public message
    When I send a public message
    Then the status code should be success

  Scenario: sending a private message
    Given a private message
    When I send a private message
    Then the status code should be success
