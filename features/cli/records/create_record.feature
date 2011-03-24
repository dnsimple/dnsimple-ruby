Feature: add a record with the CLI
  As a user
  In order to add records to a domain in my account
  I should be able to use the CLI to add records

  @announce-cmd @announce-stdout
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple create` with a new domain
    And I run `dnsimple record:create` with the domain I added and no name and the type "A" and the content "1.2.3.4"
    Then the output should show that the "A" record was created
    And the output should include the record id
