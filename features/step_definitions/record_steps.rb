When /^I run `(.*)` with the domain I added and no name and the type "([^\"]*)" and the content "([^\"]*)"$/ do |cmd, type, content|
  steps %Q(When I run `#{cmd} #{@domain_name} '' #{type} #{content}`)
end

When /^I run `(.*)` with the domain I added and the name "([^\"]*)" and the type "([^\"]*)" and the content "([^\"]*)"$/ do |cmd, name, type, content|
  steps %Q(When I run `#{cmd} #{@domain_name} #{name} #{type} #{content}`)
end

When /^I run `(.*)` with the id of the record$/ do |cmd|
  steps %Q(When I run `#{cmd} #{@domain_name} #{@record_id}`)  
end

When /^I note the id of the record I added$/ do
  ps = only_processes.last
  fail "No last process" unless ps
  m = ps.stdout.match(/id:(\d+)/)
  fail "Unable to find ID of record" unless m
  @record_id = m[1] 
end

Then /^the output should show that the "([^\"]*)" record was created$/ do |type|
  steps %Q(Then the output should contain "Created #{type} record for #{@domain_name}")
end

Then /^the output should include the record id$/ do
  steps %Q(Then the output should match /id:(\\d+)/) 
end

Then /^the output should show that the record was deleted$/ do
  steps %Q(Then the output should contain "Deleted #{@record_id} from #{@domain_name}")
end

Then /^I the domain should have (\d+) records$/ do |n|
  steps %Q(
    When I run `dnsimple record:list #{@domain_name}`
    Then the output should contain "Found #{n} records for #{@domain_name}"
  )
end
