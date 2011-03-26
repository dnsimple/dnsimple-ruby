Feature: create a contact with the CLI
  As a user
  In order to add a contact to my list of contacts
  I should be able to use the CLI to create a contact

  @announce-cmd
  Scenario:
    Given I have set up my credentials
    When I run `dnsimple contact:create first:John last:Smith address1:"Example Road" city:Anytown state:Florida postal_code:12345 country:US email:john.smith@example.com phone:12225051122 label:test-contact`
    Then the output should contain "Created contact John Smith"
