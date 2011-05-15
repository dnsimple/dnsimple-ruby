When /^I run `(.*)` with a new domain$/ do |cmd|
  @domain_name = "cli-test-#{Time.now.to_i}.com"
  steps %Q(When I run `#{cmd} #{@domain_name}`)
end

When /^I run `(.*)` with a in\-addr\.arpa domain$/ do |cmd|
  @domain_name = '0.0.10.in-addr.arpa'
  steps %Q(When I run `#{cmd} #{@domain_name}`)
end

When /^I run `(.*)` with a domain I created$/ do |cmd|
  steps %Q(
    When I run `dnsimple create` with a new domain
  )
  steps %Q(
    And I run `#{cmd} #{@domain_name}`
  )
end

Then /^the output should show that the domain was created$/ do
  steps %Q(Then the output should contain "Created #{@domain_name}")
end

Then /^the output should show that the domain was deleted$/ do
  steps %Q(Then the output should contain "Deleted #{@domain_name}")
end

Then /^the output should show that the domain was registered$/ do
  steps %Q(Then the output should contain "Registered #{@domain_name}")
end


