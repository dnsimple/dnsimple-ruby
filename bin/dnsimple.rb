#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'dnsimple'
require 'dnsimple/cli'

require 'optparse'

options = {}

global = OptionParser.new do |opts|
  
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

  cli = DNSimple::CLI.new
  begin
    cli.execute(command, ARGV, options)
  rescue DNSimple::CommandNotFound => e
    puts e.message
  end
end
