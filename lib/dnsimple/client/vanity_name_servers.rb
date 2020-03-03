# frozen_string_literal: true

module Dnsimple
  class Client
    module VanityNameServers

      # Enable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/vanity/#enableVanityNameServers
      #
      # @example Enable vanity name servers for example.com:
      #   client.vanity_name_servers.enable_vanity_name_servers(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name
      # @param  options [Hash]
      # @return [Dnsimple::Response<Array>]
      #
      # @raise  [RequestError] When the request fails.
      def enable_vanity_name_servers(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/vanity/%s" % [account_id, domain_name])
        response = client.put(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

      # Disable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/vanity/#disableVanityNameServers
      #
      # @example Disable vanity name servers for example.com:
      #   client.vanity_name_servers.disable_vanity_name_servers(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def disable_vanity_name_servers(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/vanity/%s" % [account_id, domain_name])
        response = client.delete(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

    end
  end
end
