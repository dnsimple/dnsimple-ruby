#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'dnsimple'
require 'dnsimple/cli'

cli = DNSimple::CLI.new

require 'optparse'

def usage
  $stderr.puts <<EOF

This is a command line tool for DNSimple. More information about DNSimple can
be found at http://dnsimple.com/

Before using this tool you should create a file called .dnsimple in your home 
directory and add the following to that file:

username: YOUR_USERNAME
password: YOUR_PASSWORD

Alternatively you can pass the credentials via command-line arguments, as in:

dnsimple -u username -p password command

== Commands

All commands are executed as dnsimple [options] command [command-options] args


The following commands are available:

help                                    # Show this usage
info                                    # Show your account information

list                                    # List all domains

describe domain.com                     # Describe the given domain
create [--template=short_name] \\
  domain.com                            # Add the given domain
register [--template=short_name] \\ 
  domain.com registrant_id              # Register the given domain with DNSimple
transfer domain.com registrant_id \\
  [authinfo]                            # Transfer the given domain into DNSimple
delete domain.com                       # Delete the given domain
apply domain.com template_short_name    # Apply a template to the domain

record:create [--prio=priority] \\
  domain.com name type content [ttl]    # Create the DNS record on the domain
record:list domain.com                  # List all records for the domain
record:delete domain.com record_id      # Delete the given domain

EOF
end

options = {}

global = OptionParser.new do |opts|
  opts.on("-s", "--site [ARG]") do |site|
    DNSimple::Client.base_uri = site
  end
  opts.on("-u", "--username [ARG]") do |username|
    DNSimple::Client.username = username
  end
  opts.on("-p", "--password [ARG]") do |password|
    DNSimple::Client.password = password
  end
  opts.on("-d") do
    DNSimple::Client.debug = true
  end
end

subcommands = { 
  'create' => OptionParser.new do |opts|
     opts.on("--template [ARG]") do |opt|
       options[:template] = opt 
     end
   end,
  'register' => OptionParser.new do |opts|
     opts.on("--template [ARG]") do |opt|
       options[:template] = opt
     end
  end,
  'record:create' => OptionParser.new do |opts|
     opts.on("--prio [ARG]") do |prio|
       options[:prio] = prio 
     end
  end,
}

global.order!
command = ARGV.shift
if command.nil? || command == 'help'
  usage
else
  options_parser = subcommands[command]
  options_parser.order! if options_parser
  begin
    cli.execute(command, ARGV, options)
  rescue DNSimple::CommandNotFound => e
    puts e.message
  end
end
