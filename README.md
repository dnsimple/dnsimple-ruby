# DNSimple Ruby API Wrapper  [![Build Status](https://secure.travis-ci.org/aetrion/dnsimple-ruby.png)](http://travis-ci.org/aetrion/dnsimple-ruby)

A Ruby API wrapper for the [DNSimple API](http://developer.dnsimple.com/).

[DNSimple](https://dnsimple.com/) provides DNS hosting
and domain registration that is simple and friendly.
We provide a full API and an easy-to-use web interface so you can get
your domain registered and set up with a minimal amount of effort.

## Installation

    $ gem install dnsimple-ruby

## Credentials

Create a file in your home directory called `.dnsimple`.

In this file add the following:

    username: YOUR_USERNAME
    password: YOUR_PASSWORD

Or if using an API token

    username: YOUR_USERNAME
    api_token: YOUR_API_TOKEN

## Wrapper Classes

In addition to the command line utility you may also use the included Ruby
classes directly in your Ruby applications.

Here's a short example.

    require 'rubygems'
    require 'dnsimple'

    DNSimple::Client.username   = 'YOUR_USERNAME'
    DNSimple::Client.password   = 'YOUR_PASSWORD'
    DNSimple::Client.http_proxy = {}

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

For the full API documentation visit http://rubydoc.info/gems/dnsimple-ruby
