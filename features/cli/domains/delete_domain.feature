Feature: delete a domain with the CLI
  As a user
  In order to remove a domain from my account
  I should be able to use the CLI to delete domains

  @announce-cmd @skip-delete
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple delete` with a domain I created
    Then the output should show that the domain was deleted 

