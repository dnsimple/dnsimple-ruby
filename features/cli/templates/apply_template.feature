Feature: apply a template to a domain
  As a user
  In order to apply a set of records to a domain at once
  I should be able to use the CLI to apply a template

  Scenario:
    Given I have set up my credentials
    When I run `dnsimple create` with a new domain
    And I run `dnsimple apply` with the domain and the template named "googleapps"
    Then the output should show that the template was applied
    And I the domain should have 13 records
