require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run tests.'
task :default => [:spec]

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DNSimple Ruby'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "dnsimple-ruby"
    gemspec.summary = "A ruby wrapper for the DNSimple API"
    gemspec.description = "A ruby wrapper for the DNSimple API that also includes a command-line client."
    gemspec.email = "anthony.eden@dnsimple.com"
    gemspec.homepage = "http://github.com/aetrion/dnsimple-ruby"
    gemspec.authors = ["Anthony Eden"]
    gemspec.add_dependency "httparty"
    gemspec.executables = 'dnsimple'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

