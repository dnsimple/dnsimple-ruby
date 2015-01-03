module Dnsimple
  class Client
    module NameServers

      # Lists the name servers for a domain.
      #
      # @see http://developer.dnsimple.com/domains/nameservers/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Array<String>] The delegates name servers.
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list(domain)
        response = client.get("v1/domains/#{domain}/name_servers")

        response.parsed_response
      end

      # Changes the name servers for a domain.
      #
      # @see http://developer.dnsimple.com/domains/nameservers/#change
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Array<String>] servers The name server list.
      #
      # @return [Array<String>] The delegates name servers.
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def change(domain, servers)
        servers = servers.inject({}) { |hash, server| hash.merge("ns#{hash.length + 1}" => server) }
        options = { name_servers: servers }
        response = client.post("v1/domains/#{domain}/name_servers", options)

        response.parsed_response
      end


      # Registers a name server at the registry.
      #
      # @see http://developer.dnsimple.com/nameservers/#register
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [String] name The hostname to register.
      # @param  [String] ip The hostname IP address.
      #
      # @return [void]
      # @raise  [RequestError] When the request fails.
      def register(domain, name, ip)
        options = { name_server: { name: name, ip: ip } }
        client.post("v1/domains/#{domain}/registry_name_servers", options)
      end

      # De-registers a name server at the registry.
      #
      # @see http://developer.dnsimple.com/nameservers/#deregister
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [String] name The hostname to register.
      #
      # @return [void]
      # @raise  [RequestError] When the request fails.
      def deregister(domain, name)
        client.delete("v1/domains/#{domain}/registry_name_servers/#{name}")
      end

    end
  end
end
