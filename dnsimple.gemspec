# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'dnsimple/version'

Gem::Specification.new do |s|
  s.name        = 'dnsimple'
  s.version     = Dnsimple::VERSION
  s.authors     = ['DNSimple']
  s.email       = ['support@dnsimple.com']
  s.homepage    = 'https://github.com/dnsimple/dnsimple-ruby'
  s.summary     = 'The DNSimple API client for Ruby'
  s.description = 'The DNSimple API client for Ruby.'

  s.required_ruby_version = ">= 2.7"

  s.require_paths    = ['lib']
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = %w( LICENSE.txt )

  s.add_dependency 'httparty'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'webmock'
end
