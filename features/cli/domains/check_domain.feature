Feature: check a domain with the CLI
  As a user
  In order to check if a domain is available for registration
  I should be able to use the CLI to check domains

  @announce-cmd
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple check domain.com`
    Then the output should contain "Check domain result for domain.com: registered"
