Feature: delete a record with the CLI
  As a user
  In order to remove a record from a domain in my account
  I should be able to use the CLI to delete a record

  @announce-cmd @announce-stdout
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple create` with a new domain
    And I run `dnsimple record:create` with the domain I added and no name and the type "A" and the content "1.2.3.4"
    And I note the id of the record I added
    And I run `dnsimple record:delete` with the id of the record
    Then the output should show that the record was deleted
     
