Given /^I have set up my credentials$/ do
  path = DNSimple::Client.config_path 
  File.exists?(File.expand_path(path)).should be_true, "Please set up your #{path} file to continue"
  credentials = YAML.load(File.new(File.expand_path(path)))
  credentials['username'].should_not be_nil, "You must specify a username in your #{path} file"
  credentials['password'].should_not be_nil, "You must specify a password in your #{path} file"
  (credentials['host'] || credentials['site']).should_not be_nil, "For cucumber to run, you must specify a host or site in your #{path} file"
end
