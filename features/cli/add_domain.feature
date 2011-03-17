Feature: add a domain with the CLI
  As a user
  In order to add a domain to my account
  I should be able to use the CLI to add domains

  @announce-cmd
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple create` with a new domain
    Then the output should show that the domain was created 
