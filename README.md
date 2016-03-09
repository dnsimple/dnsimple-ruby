# DNSimple Ruby Client

A Ruby client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

[![Build Status](https://travis-ci.org/aetrion/dnsimple-ruby.svg?branch=master)](https://travis-ci.org/aetrion/dnsimple-ruby)
[![Coverage Status](https://img.shields.io/coveralls/aetrion/dnsimple-ruby.svg)](https://coveralls.io/r/aetrion/dnsimple-ruby?branch=master)

[DNSimple](https://dnsimple.com/) provides DNS hosting and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get your domain registered and set up with a minimal amount of effort.


## :warning: Beta Warning

This branch targets the development of the API client for the [DNSimple API v2](https://developer.dnsimple.com/v2/). If you are looking for the stable version of the client for [DNSimple API v1](https://developer.dnsimple.com/v1/) then use the [`master-v1`](https://github.com/aetrion/dnsimple-ruby/tree/master-v1) branch.

This library is currently in beta version, the methods and the implementation should be considered a work-in-progress. Changes in the method naming, method signatures, public or internal APIs may happen during the beta period.


## Installation

During the initial beta period, releases of this gem are flagged as [prerelease](http://guides.rubygems.org/patterns/#prerelease-gems). You will need to append `--pre` in order to install the beta client.

```
$ gem install dnsimple --pre
```

Also note that Bundler ignores pre-releases by default. To use a pre-release gem, make sure to explicitly add the release version.

```
gem 'dnsimple', '~> 3.0', '>= 3.0.0.pre.beta1'
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


## License

Copyright (c) 2010-2016 Aetrion LLC. This is Free Software distributed under the MIT license.
