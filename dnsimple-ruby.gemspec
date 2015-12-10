# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'dnsimple-ruby'
  s.version     = '2.0.0'
  s.authors     = ['Anthony Eden', 'Simone Carletti']
  s.email       = ['anthony.eden@dnsimple.com', 'simone.carletti@dnsimple.com']
  s.homepage    = 'https://github.com/aetrion/dnsimple-ruby'
  s.summary     = 'This gem is deprecated, please use dnsimple.'
  s.description = 'The DNSimple API client for Ruby. This gem is deprecated, please use dnsimple.'

  s.required_ruby_version = ">= 1.9.3"

  s.require_paths    = ['lib']
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = %w( README.md CHANGELOG.md LICENSE )

  s.add_dependency  'dnsimple', '>= 2.0'
end