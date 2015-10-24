Feature: Post sharing requests
  As a user of diaspora federation
  I should be able to set up relationships with other pods' users

  Background:
    Given an existing server
    And an existing user account at the testbed
    And an existing webfinger document
    And I make a hcard-request
    And I should receive a valid hcard document

  Scenario: post a request
    Given a sharing request
    When I send a private message
    Then the status code should be success
