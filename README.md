# DNSimple Ruby Client

A Ruby client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

[![Build Status](https://travis-ci.com/dnsimple/dnsimple-ruby.svg?branch=master)](https://travis-ci.com/dnsimple/dnsimple-ruby)
[![Coverage Status](https://img.shields.io/coveralls/dnsimple/dnsimple-ruby.svg)](https://coveralls.io/r/dnsimple/dnsimple-ruby?branch=master)

[DNSimple](https://dnsimple.com/) provides DNS hosting and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get your domain registered and set up with a minimal amount of effort.


## Installation

You can install the gem manually:

```
gem install dnsimple
```

Or use Bundler and define it as a dependency in your Gemfile:

```
gem 'dnsimple', '~> 4.0'
```

## Usage

This library is a Ruby client you can use to interact with the [DNSimple API v2](https://developer.dnsimple.com/v2/). Here are some examples.

```ruby
require 'dnsimple'

client = Dnsimple::Client.new(access_token: "a1b2c3")

# Fetch your details
response = client.identity.whoami   # execute the call
response.data                       # extract the relevant data from the response or
client.identity.whoami.data         # execute the call and get the data in one line

# Define an account ID.
account_id = 1010

# You can also fetch it from the whoami response
# as long as you authenticate with an Account access token
whoami = client.identity.whoami.data
account_id = whoami.account.id

# List your domains
puts client.domains.list_domains(account_id).data                      # => domains from the account 1234, first page
puts client.domains.list_domains(account_id, query: { page: 3 }).data  # => domains from the account 1234, third page
puts client.domains.all_domains(account_id).data                       # => all domains from the account 1234 (use carefully)

# Create a domain
response = client.domains.create_domain(account_id, name: "example.com")
puts response.data

# Get a domain
response = client.domains.domain(account_id, "example.com")
puts response.data
```

For the full library documentation visit http://rubydoc.info/gems/dnsimple


## Sandbox Environment

We highly recommend testing against our [sandbox environment](https://developer.dnsimple.com/sandbox/) before using our production environment. This will allow you to avoid real purchases, live charges on your credit card, and reduce the chance of your running up against rate limits.

The client supports both the production and sandbox environment. To switch to sandbox pass the sandbox API host using the `base_url` option when you construct the client:

```ruby
client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: "a1b2c3")
```

You will need to ensure that you are using an access token created in the sandbox environment. Production tokens will *not* work in the sandbox environment.


## Setting a custom `User-Agent` header

You can customize the `User-Agent` header for the calls made to the DNSimple API:

```ruby
client = Dnsimple::Client.new(user_agent: "my-app/1.0")
```

The value you provide will be prepended to the default `User-Agent` the client uses. For example, if you use `my-app/1.0`, the final header value will be `my-app/1.0 dnsimple-ruby/0.14.0` (note that it will vary depending on the client version).

We recommend to customize the user agent. If you are building a library or integration on top of the official client, customizing the client will help us to understand what is this client used for, and allow to contribute back or get in touch.


## License

Copyright (c) 2010-2020 DNSimple Corporation. This is Free Software distributed under the MIT license.
