require 'bundler/gem_tasks'


desc 'Default: run tests.'
task :default => [:spec]


require 'rdoc/task'

desc 'Generate documentation.'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DNSimple Ruby'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
