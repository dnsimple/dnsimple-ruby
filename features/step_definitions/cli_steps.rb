After do
  if @domain_name && @domain_name =~ /^cli-/
    steps %Q(When I run `dnsimple delete #{@domain_name}`)
  end
end

Given /^I have set up my credentials$/ do
  File.exists?(File.expand_path('~/.dnsimple')).should be_true, "Please set up your ~/.dnsimple file to continue"
end

When /^I run `(.*)` with a new domain$/ do |cmd|
  @domain_name = "cli-test-#{Time.now.to_i}.com"
  steps %Q(When I run `#{cmd} #{@domain_name}`)
end

When /^I run `(.*)` with the domain I added and no name and the type "([^\"]*)" and the content "([^\"]*)"$/ do |cmd, type, content|
  steps %Q(When I run `#{cmd} #{@domain_name} '' #{type} #{content}`)
end

Then /^the output should show that the domain was created$/ do
  steps %Q(Then the output should contain "Created #{@domain_name}")
end

Then /^the output should show that the "([^\"]*)" record was created$/ do |type|
  steps %Q(Then the output should contain "Created #{type} record for #{@domain_name}")
end


