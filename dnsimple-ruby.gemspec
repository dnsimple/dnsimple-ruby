# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'dnsimple/version'

Gem::Specification.new do |s|
  s.name        = 'dnsimple-ruby'
  s.version     = DNSimple::VERSION
  s.authors     = ['Anthony Eden']
  s.email       = ['anthony.eden@dnsimple.com']
  s.homepage    = 'http://github.com/aetrion/dnsimple-ruby'
  s.summary     = 'A ruby wrapper for the DNSimple API'
  s.description = 'A ruby wrapper for the DNSimple API that also includes a command-line client.'

  s.require_paths    = ['lib']
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = %w( LICENSE README README.rdoc README.textile )
  s.executables      = `git ls-files -- bin/*`.split("\n").collect { |f|
    File.basename(f)
  }

  s.add_runtime_dependency     'httparty', '>= 0'

  s.add_development_dependency 'rake',     '~> 0.9.0'
  s.add_development_dependency 'aruba',    '>= 0'
  s.add_development_dependency 'cucumber', '>= 0'
  s.add_development_dependency 'fakeweb',  '>= 0'
  s.add_development_dependency 'mocha',    '>= 0'
  s.add_development_dependency 'rspec',    '>= 2.0.0'
  s.add_development_dependency 'rdoc',     '~> 3.12.0'
end
