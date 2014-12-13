# DNSimple Ruby Client

A Ruby client for the [DNSimple API](http://developer.dnsimple.com/).

[![Build Status](https://travis-ci.org/aetrion/dnsimple-ruby.svg?branch=master)](https://travis-ci.org/aetrion/dnsimple-ruby)
[![Coverage Status](https://img.shields.io/coveralls/aetrion/dnsimple-ruby.svg)](https://coveralls.io/r/aetrion/dnsimple-ruby?branch=master)

[DNSimple](https://dnsimple.com/) provides DNS hosting and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get your domain registered and set up with a minimal amount of effort.


## Installation

    $ gem install dnsimple-ruby


## DNSimple Client

This library provides a Ruby DNSimple client you can use to interact with the [DNSimple API](http://developer.dnsimple.com/). Here's a short example.

```ruby
require 'dnsimple'

DNSimple::Client.username   = 'YOUR_USERNAME'
DNSimple::Client.password   = 'YOUR_PASSWORD'

user = DNSimple::User.me
puts "#{user.domain_count} domains"

puts "Domains..."
DNSimple::Domain.all.each do |domain|
  puts "  #{domain.name}"
end

domain = DNSimple::Domain.find("example.com")
domain.apply("template") # applies a standard or custom template to the domain

domain = DNSimple::Domain.create("newdomain.com")
puts "Added #{domain.name}"
domain.delete # removes from DNSimple
```

For the full API documentation visit http://rubydoc.info/gems/dnsimple-ruby

### Authentication

This client supports both the HTTP Basic and API Token authentication mechanism.

#### HTTP Basic

```ruby
DNSimple::Client.username = 'YOUR_USERNAME'
DNSimple::Client.password = 'YOUR_PASSWORD'

user = DNSimple::User.me
```

#### HTTP Basic with two-factor authentication enabled

See the [2FA API documentation](http://developer.dnsimple.com/authentication/#twofa).

```ruby
# Request the 2FA exchange token
DNSimple::Client.username = 'YOUR_USERNAME'
DNSimple::Client.password = 'YOUR_PASSWORD'
token = DNSimple::User.two_factor_exchange_token('otp-token')

# Authenticate with the exchange token
DNSimple::Client.exchange_token = token
user = DNSimple::User.me
```

#### API Token

```ruby
DNSimple::Client.api_token = 'the-token'

user = DNSimple::User.me
```
