Given /^I have set up my credentials$/ do
  File.exists?(File.expand_path('~/.dnsimple')).should be_true, "Please set up your ~/.dnsimple file to continue"
end
