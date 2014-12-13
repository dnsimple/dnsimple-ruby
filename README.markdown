# DNSimple Ruby Client

A Ruby client for the [DNSimple API](http://developer.dnsimple.com/).

[![Build Status](https://travis-ci.org/aetrion/dnsimple-ruby.svg?branch=master)](https://travis-ci.org/aetrion/dnsimple-ruby)
[![Coverage Status](https://img.shields.io/coveralls/aetrion/dnsimple-ruby.svg)](https://coveralls.io/r/aetrion/dnsimple-ruby?branch=master)

[DNSimple](https://dnsimple.com/) provides DNS hosting and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get your domain registered and set up with a minimal amount of effort.


## Installation

```
$ gem install dnsimple
```


## Getting Started

This library is a Ruby client you can use to interact with the [DNSimple API](http://developer.dnsimple.com/). 

Here's a short example.

```ruby
require 'dnsimple'

Dnsimple::Client.username = 'YOUR_USERNAME'
Dnsimple::Client.password = 'YOUR_PASSWORD'

# Fetch your user details
user = Dnsimple::User.me
puts "My email is #{user.email}"

# Get a list of your domains
domains = Dnsimple::Domain.list
domains.each do |domain|
  puts "Domain: %s (id: %d)" % [domain.name, domain.id]
end

# Create a domain
domain = Dnsimple::Domain.create("example.com")
puts "Domain: %s (id: %d)" % [domain.name, domain.id]
```

For the full library documentation visit http://rubydoc.info/gems/dnsimple


## Authentication

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
DNSimple::Client.username  = 'YOUR_USERNAME'
DNSimple::Client.api_token = 'API_TOKEN'

user = DNSimple::User.me
```
