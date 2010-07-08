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
   'delete' => OptionParser.new do |opts|
   end
}

global.order!
command = ARGV.shift
subcommands[command].order!

cli = DNSimple::CLI.new
begin
  cli.execute(command, ARGV, options)
rescue DNSimple::CommandNotFound => e
  puts e.message
end
