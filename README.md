## :exclamation: Development Warning :exclamation:

This branch targets the development of the API client for the [DNSimple API v2](https://developer.dnsimple.com/v2/). If you are looking for the stable version of the client for [DNSimple API v1](https://developer.dnsimple.com/v1/) then use the [`master-v1`](https://github.com/aetrion/dnsimple-ruby/tree/master-v1) branch.

This version is currently under development, therefore the methods and the implementation should he considered a work-in-progress. Changes in the method naming, method signatures, public or internal APIs may happen at any time.

The code is tested with an automated test suite connected to a continuous integration tool, therefore you should not expect :bomb: bugs to be merged into master. Regardless, use this library at your own risk. :boom:


# DNSimple Ruby Client

A Ruby client for the [DNSimple API v2](https://developer.dnsimple.com/v2/).

[![Build Status](https://travis-ci.org/aetrion/dnsimple-ruby.svg?branch=api-v2)](https://travis-ci.org/aetrion/dnsimple-ruby)
[![Coverage Status](https://img.shields.io/coveralls/aetrion/dnsimple-ruby.svg)](https://coveralls.io/r/aetrion/dnsimple-ruby?branch=api-v2)

[DNSimple](https://dnsimple.com/) provides DNS hosting and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get your domain registered and set up with a minimal amount of effort.


## Installation

```
$ gem install dnsimple
```


## Getting Started

This library is a Ruby client you can use to interact with the [DNSimple API v2](https://developer.dnsimple.com/v2/). Here are some examples.

```ruby
require 'dnsimple'

client = Dnsimple::Client.new(access_token: "a1b2c3")

# Fetch your details
response = client.domains.whoami    # execute the call
response.data                       # extract the relevant data from the response or
client.domains.whoami.data          # execute the call and get the data in one line

# List your domains
client.domains.list(1234).data                      # => domains from the account 1234, first page
client.domains.list(1234, query: { page: 3 }).data  # => domains from the account 1234, third page
client.domains.all(1234).data                       # => all domains from the account 1234 (use carefully)

# Create a domain

# Get a domain

# Create a domain record

# Get a domain record

# List domain records
```

For the full library documentation visit http://rubydoc.info/gems/dnsimple


## Authentication


## License

Copyright (c) 2010-2016 Aetrion LLC. This is Free Software distributed under the MIT license.
