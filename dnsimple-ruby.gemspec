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
  s.extra_rdoc_files = %w( README.md CHANGELOG.md LICENSE )
  s.executables      = `git ls-files -- bin/*`.split("\n").collect { |f|
    File.basename(f)
  }

  s.add_runtime_dependency     'httparty', '>= 0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'yard'
end
