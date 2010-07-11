#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'dnsimple'
require 'dnsimple/cli'

cli = DNSimple::CLI.new

require 'optparse'

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
end

subcommands = { 
  'create' => OptionParser.new do |opts|
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
if command.nil?
  puts "You must specify a command"
else
  options_parser = subcommands[command]
  options_parser.order! if options_parser
  begin
    cli.execute(command, ARGV, options)
  rescue DNSimple::CommandNotFound => e
    puts e.message
  end
end
