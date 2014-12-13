# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'dnsimple/version'

Gem::Specification.new do |s|
  s.name        = 'dnsimple'
  s.version     = Dnsimple::VERSION
  s.authors     = ['Anthony Eden', 'Simone Carletti']
  s.email       = ['anthony.eden@dnsimple.com', 'simone.carletti@dnsimple.com']
  s.homepage    = 'http://github.com/aetrion/dnsimple-ruby'
  s.summary     = 'A Ruby client for the DNSimple API'
  s.description = 'A Ruby client for the DNSimple API that also includes a command-line client.'

  s.required_ruby_version = ">= 1.9.3"

  s.require_paths    = ['lib']
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = %w( README.markdown CHANGELOG.markdown LICENSE )

  s.add_dependency  'httparty'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'webmock'
end
