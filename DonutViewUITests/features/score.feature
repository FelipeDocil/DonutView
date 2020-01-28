Feature: View score on Dashboard

  @ios @android
  Scenario Outline: User can see the score
    Given User is on the Dashboard screen
    When User <hasOrNot> network
    Then User <canOrNot> see the score

    Examples:
      | hasOrNot | canOrNot |
      | has      | can      |
      | has not  | cannot   |
