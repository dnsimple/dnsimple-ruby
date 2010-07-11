require 'lib/dnsimple'

config = YAML.load(File.new(File.expand_path('~/.dnsimple.localhost')))

DNSimple::Client.base_uri = config['site'] || "http://localhost:3000/" 
DNSimple::Client.username = config['username']
DNSimple::Client.password = config['password'] 
