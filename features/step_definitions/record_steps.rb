When /^I run `(.*)` with the domain I added and no name and the type "([^\"]*)" and the content "([^\"]*)"$/ do |cmd, type, content|
  steps %Q(When I run `#{cmd} #{@domain_name} '' #{type} #{content}`)
end

When /^I run `(.*)` with the domain I added and the name "([^\"]*)" and the type "([^\"]*)" and the content "([^\"]*)"$/ do |cmd, name, type, content|
  steps %Q(When I run `#{cmd} #{@domain_name} #{name} #{type} #{content}`)
end

Then /^the output should show that the "([^\"]*)" record was created$/ do |type|
  steps %Q(Then the output should contain "Created #{type} record for #{@domain_name}")
end
