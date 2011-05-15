Then /^the output should show that a certificate was purchased$/ do
  steps %Q(Then the output should contain "Purchased certificate for #{@domain_name}")
end
