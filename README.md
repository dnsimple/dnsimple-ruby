# DNSimple Ruby Client

A Ruby command line utility and wrapper for the [DNSimple API](https://dnsimple.com/documentation/api).

[![Build Status](https://secure.travis-ci.org/aetrion/dnsimple-ruby.png)](http://travis-ci.org/aetrion/dnsimple-ruby)

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

## Commands

There are two ways to interact with the DNSimple Ruby wrapper. The first is
to use the command line utility that is included. The commands available 
are as follows:

For help:

- dnsimple help

The following commands are available for domains:

- dnsimple list
- dnsimple describe domain.com
- dnsimple create domain.com
- dnsimple register domain.com registrant_id
- dnsimple transfer domain.com registrant_id [authinfo]
- dnsimple delete domain.com
- dnsimple apply domain.com template_short_name

Please note that domain registration and transfer can only be done through the API for domains that do not require extended attributes. A future version of the API will add support for extended attributes.

The following commands are available for records:

- dnsimple record:create [--prio=priority] domain.com name type content [ttl]
- dnsimple record:list domain.com
- dnsimple record:delete domain.com record_id

The following commands are available for custom templates:

- dnsimple template:list
- dnsimple template:create name short_name [description]
- dnsimple template:delete short_name
- dnsimple template:list_records short_name
- dnsimple template:add_record short_name name type content [ttl] [prio]
- dnsimple template:delete_record short_name template_record_id

The following commands are available for managing contacts:

- dnsimple contact:list
- dnsimple contact:describe id
- dnsimple contact:create [name:value name:value ...]
- dnsimple contact:update id [name:value name:value ...]
- dnsimple contact:delete id

The following commands are available for purchasing certificates:

- dnsimple certificate:purchase domain.com name contact_id
- dnsimple certificate:submit id

The contact name/value pairs are: 
 
- first_name
- last_name
- organization_name (optional)
- job_title (required if organization name is specified)
- address1
- address2 (optional)
- city
- state_province (also aliased as state)
- postal_code
- country
- email
- phone
- phone_ext (optional)
- fax (optional)

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
