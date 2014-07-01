Given /^I have set up my credentials$/ do
  path = DNSimple::Client.config_path 
  File.exists?(File.expand_path(path)).should be_truthy, "Please set up your #{path} file to continue"
  credentials = YAML.load(File.new(File.expand_path(path)))
  expect(credentials['username']).to_not be_nil, "You must specify a username in your #{path} file"
  expect(credentials['password']).to_not be_nil, "You must specify a password in your #{path} file"
  expect(credentials['base_uri']).to_not be_nil, "For cucumber to run, you must specify a base_uri in your #{path} file"
end
