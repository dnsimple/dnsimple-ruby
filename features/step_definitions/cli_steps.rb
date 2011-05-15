Given /^I have set up my credentials$/ do
  path = '~/.dnsimple'
  File.exists?(File.expand_path(path)).should be_true, "Please set up your ~/.dnsimple file to continue"
  credentials = YAML.load(File.new(File.expand_path(path)))
  credentials['username'].should_not be_nil, "You must specify a username in your .dnsimple file"
  credentials['password'].should_not be_nil, "You must specify a password in your .dnsimple file"
  credentials['site'].should_not be_nil, "For cucumber to run, you must specify a site in your .dnsimple file"
end
