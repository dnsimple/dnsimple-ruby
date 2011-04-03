Feature: register a domain with the CLI
  As a user
  In order to register a domain
  I should be able to use the CLI for domain registration

  @announce-cmd @announce-stdout
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple register` with a new domain
    Then the output should show that the domain was registered
