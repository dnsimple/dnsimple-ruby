require 'bundler/gem_tasks'

# Run test by default.
task :default => :spec


require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.verbose = !ENV["VERBOSE"].nil?
end


require 'yard'

YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  task :clobber do
    rm_r "yardoc" rescue nil
  end
end

task :clobber => "yardoc:clobber"


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r dnsimple.rb"
end
