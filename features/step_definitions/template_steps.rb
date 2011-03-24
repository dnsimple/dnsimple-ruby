When /^I run `(.*)` with the domain and the template named "([^\"]*)"$/ do |cmd, template|
  @template_name = template
  steps %Q(When I run `#{cmd} #{@domain_name} #{template}`)
end

Then /^the output should show that the template was applied$/ do
  steps %Q(Then the output should contain "Applied template #{@template_name} to #{@domain_name}")
end

