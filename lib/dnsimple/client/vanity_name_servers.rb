module Dnsimple
  class Client
    module VanityNameServers

      # Enable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/vanity/#enable
      #
      # @example Enable vanity name servers for example.com:
      #   client.vanity_name_servers.enable(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Hash] options
      # @return [Dnsimple::Response<Array>]
      #
      # @raise  [RequestError] When the request fails.
      def enable(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/vanity/%s" % [account_id, domain_name])
        response = client.put(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

      # Disable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/vanity/#disable
      #
      # @example Disable vanity name servers for example.com:
      #   client.vanity_name_servers.disable(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def disable(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/vanity/%s" % [account_id, domain_name])
        response = client.delete(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

    end
  end
end
