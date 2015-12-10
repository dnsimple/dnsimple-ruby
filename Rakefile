require 'bundler/gem_tasks'

# Run test by default.
task :default => :spec


require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.verbose = !!ENV["VERBOSE"]
end


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r dnsimple.rb"
end
