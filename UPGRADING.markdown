# Upgrading to v2.0

v2.0 is a major upgrade over v1.x and is not backward compatible.

The client has been completely rewritten from scratch to provide a more consistent interface
and take advantage of Ruby 1.9.3 and Ruby 2.0.

If you are upgrading your code from v1.x, here's the major changes you should be aware of.


1.  The client is now an instance.

    All the API calls are performed within the scope of an instance, rather than a class,
    making it possible to pass the client around, write thread-safe code and create multiple client instances
    with different API credentials for a multi-environment application.

    ```ruby
    # v1
    DNSimple::Client.username   = 'YOUR_USERNAME'
    DNSimple::Client.password   = 'YOUR_PASSWORD'
    domain = DNSimple::Domain.find("example.com")

    # v2
    client = Dnsimple::Client.new(username: 'YOUR_USERNAME', password: 'YOUR_PASSWORD')
    domain = client.domains.domain("example.com")
    ```

1.  API call responses are now simple struct-like objects, rather Model-like objects.

    ```ruby
    domain = client.domains.domain("example.com")
    # => Dnsimple::Struct::Domain
    ```

    A struct-like object is designed to be a simple container of key/value attributes,
    as opposite to a fully-features instance you can interact with.

1.  API methods are now defined as methods of the client instance.

    This is a consequence (or the cause, depending on the POV) of the previous point. It is no longer possible to call
    persistence methods on an object returned from the API, as it was in v1.

    ```ruby
    record = client.domains.record("example.com", 1)
    # this will fail
    record.name = "www"
    record.update
    ```

    Instead, treat the object a simple read-only container. If you need to manipulate a Record, Domain or another instance,
    write your own object that encapsulate the desired persistence behavior.

    Here's a very simple example.

    ```ruby
    class DnsimpleRecord
      def self.find(client, domain, record_id)
        client.record(domain, record_id)
      end

      def self.create(client, domain, attributes)
        new(client.create_record(domain, attributes))
      end

      def initialize(client, instance)
        @client   = client
        @instance = instance
      end

      def update_ip(ip)
        @client.update_record(@instance.domain_id, @instance.record_id, content: ip)
      end
    end
    ```

    Although this approach seems more verbose at first glance, it encourages the encapsulation of your application logic
    inside custom objects, rather than promoting the patching of the core library objects.

    Moreover, we found that in most cases developers need access to a very limited set of operations
    rather all the possible API methods attached to a resource. And it's likely you already have a model in your application,
    what you need is just a simple way to interact with the third-party DNSimple application.

    Last but not least, this approach guarantees that if you want to alter the state of an object and you already know
    its id, you don't need to perform a #find call to instantiate an object to call the update on:

    ```ruby
    # version 1
    record = Dnsimple::Record.find("example.com", 12)
    record.name = "updated"
    record.content = "127.0.0.1"
    record.update

    # version 2
    record = Dnsimple::Record.find("example.com", 12)
    record.update(name: "updated", content: "127.0.0.1")
    ```

    Instead, simply execute

    ```ruby
    client.domains.update_record("example.com", 12, name: "updated", content: "127.0.0.1")
    ```