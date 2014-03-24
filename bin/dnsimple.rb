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

check domain.com                                            # Check if a domain is available (for registration)
create [--template=short_name] domain.com                   # Add the given domain
register [--template=short_name] domain.com registrant_id \ # Register the given domain with DNSimple
  [[name:value] [name:value]]                               # name:value pairs can be given for extended attributes
transfer domain.com registrant_id [authinfo] \              # Transfer the given domain into DNSimple
  [[name:value] [name:value] ...]                           # name:value pairs can be given for extended attributes
describe domain.com                                         # Describe the given domain
list                                                        # List all domains
delete domain.com                                           # Delete the given domain
clear domain.com                                            # Remove all records from the domain 
apply domain.com template_short_name                        # Apply a template to the domain

record:describe domain.com record_id                        # Describe the given record
record:create [--prio=priority] domain.com name type \\
  content [ttl]                                             # Create the DNS record on the domain
record:list domain.com                                      # List all records for the domain
record:update domain.com record_id \                        # Update a specific record
  [[name:value] [name:value] ...]                           # name:value pairs are given for updateable attributes
record:delete domain.com record_id                          # Delete the given domain

template:create name short_name [description]               # Create a template
template:list                                               # List all templates
template:delete short_name                                  # Delete the given template

template:list_records short_name                            # List all of the records for a template
template:add_record [--prio=priority] short_name name \\ 
  type content [ttl]                                        # Add a template record to the given template
template:delete_record short_name template_record_id        # Delete the given template record

contact:create [[name:value [name:value] ...]               # Create a contact
contact:list                                                # List all contacts
contact:describe contact_id                                 # Describe the given contact
contact:update contact_id [[name:value] [name:value] ...]   # Update the given contact
contact:delete contact_id                                   # Delete the given contact

extended-attributes:list tld                                # List all extended attributes for the given TLD

service:list                                                # List all supported services
service:describe short_name                                 # Describe a specific service

service:applied domain.com                                  # List all of the services applied to the domain
service:available domain.com                                # List all of the services available for the domain
service:add domain.com short_name                           # Add the service to the domain
service:remove domain.com short_name                        # Remove the service from the domain

certificate:list domain.com                                 # List all certificates for a domain
certificate:describe domain.com id                          # Get a specific certificate for a domain
certificate:purchase domain.com name contact_id             # Purchase a certificate
certificate:submit domain.com id approver_email             # Submit a certificate for processing

Please see the DNSimple documentation at http://developer.dnsimple.com for additional
information on the commands that are available to DNSimple customers.

EOF
end

if $0.split("/").last == 'dnsimple'

  options = {}

  global = OptionParser.new do |opts|
    opts.on("-s", "--site [ARG]") do |site|
      DNSimple::Client.site_uri = site
    end
    opts.on("-u", "--username [ARG]") do |username|
      DNSimple::Client.username = username
    end
    opts.on("-p", "--password [ARG]") do |password|
      DNSimple::Client.password = password
    end
    opts.on("-c", "--credentials [ARG]") do |credentials|
      DNSimple::Client.load_credentials(credentials)
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
    'template:add_record' => OptionParser.new do |opts|
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

end
