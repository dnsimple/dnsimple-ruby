Feature: add a PTR record with the CLI
  As a user
  In order to add a PTR record to a domain in my account
  I should be able to use the CLI to add the PTR record

  @announce-cmd @announce-stdout
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple create` with a in-addr.arpa domain
    And I run `dnsimple record:create` with the domain I added and the name "1" and the type "PTR" and the content "domain.com"
    Then the output should show that the "PTR" record was created
