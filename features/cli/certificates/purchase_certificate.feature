Feature: purchase a certificate with the CLI
  As a user
  In order to purchase a certificate
  I should be able to use the CLI for purchasing a certificate

  @announce-cmd @announce-stdout
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple certificate:purchase` with a domain I created
    Then the output should show that a certificate was purchased
