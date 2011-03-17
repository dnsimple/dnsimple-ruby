When /^I run `(.*)` with a new domain$/ do |cmd|
  @domain_name = "cli-test-#{Time.now.to_i}.com"
  steps %Q(When I run `#{cmd} #{@domain_name}`)
end

When /^I run `(.*)` with a in\-addr\.arpa domain$/ do |cmd|
  @domain_name = '0.0.10.in-addr.arpa'
  steps %Q(When I run `#{cmd} #{@domain_name}`)
end

Then /^the output should show that the domain was created$/ do
  steps %Q(Then the output should contain "Created #{@domain_name}")
end
