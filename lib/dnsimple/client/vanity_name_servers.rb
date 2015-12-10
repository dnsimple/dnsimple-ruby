module Dnsimple
  class Client
    module VanityNameServers

      # Enable vanity name servers for a domain. 
      #
      # @see https://developer.dnsimple.com/v1/nameservers/vanity-nameservers/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] names A hash of up to 4 external name servers; hash keys
      # are ns1 through ns4, e.g.
      #         {
      #           "ns1" => "ns1.example.com",
      #           "ns2" => "ns2.example.com"
      #         }
      #
      # @return [void]
      # @raise  [RequestError] When the request fails.
      def enable_vanity_name_servers(domain, names)
        options = {
                    "vanity_nameserver_configuration" => {
                      "server_source" => "external"
                    }
                  }
        options["vanity_nameserver_configuration"].merge!(names)
        client.post(Client.versioned("domains/#{domain}/vanity_name_servers"), options)
      end

      # Disable vanity name servers for a domain.
      #
      # @see https://developer.dnsimple.com/v1/nameservers/vanity-nameservers/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [void]
      # @raise  [RequestError] When the request fails.
      def disable_vanity_name_servers(domain)
        client.delete("v1/domains/#{domain}/vanity_name_servers")
      end

    end
  end
end
