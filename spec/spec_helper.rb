require 'lib/dnsimple'

config = YAML.load(File.new(File.expand_path('~/.dnsimple.test')))

DNSimple::Client.base_uri = config['site'] || "https://test.dnsimple.com/" 
DNSimple::Client.username = config['username']
DNSimple::Client.password = config['password'] 
