# frozen_string_literal: true

module Dnsimple
  class Client
    module RegistrarDelegation
      # Lists name servers the domain is delegating to.
      #
      # @see https://developer.dnsimple.com/v2/registrar/delegation/#list
      #
      # @example List the name servers example.com is delegating to:
      #   client.registrar.domain_delegation(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name to check
      # @param  options [Hash]
      # @return [Dnsimple::Response<Array>]
      #
      # @raise  [RequestError] When the request fails.
      def domain_delegation(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

      # Chagne name servers the domain is delegating to.
      #
      # @see https://developer.dnsimple.com/v2/registrar/delegation/#update
      #
      # @example Change the name servers example.com is delegating to:
      #   client.registrar.change_domain_delegation(1010, "example.com",
      #       ["ns1.dnsimple.com", "ns2.dnsimple.com", "ns3.dnsimple.com", "ns4.dnsimple.com"])
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name to check
      # @param  attributes [Array]
      # @param  options [Hash]
      # @return [Dnsimple::Response<Array>]
      #
      # @raise  [RequestError] When the request fails.
      def change_domain_delegation(account_id, domain_name, attributes, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation" % [account_id, domain_name])
        response = client.put(endpoint, attributes, options)

        Dnsimple::Response.new(response, response["data"])
      end

      # Enable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/delegation/#delegateToVanity
      #
      # @example Enable vanity name servers for example.com:
      #   client.registrar.change_domain_delegation_to_vanity(1010, "example.com",
      #       ["ns1.example.com", "ns2.example.com", "ns3.example.com", "ns4.example.com"])
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name to check
      # @param  attributes [Array]
      # @param  options [Hash]
      # @return [Dnsimple::Response<Array<Dnsimple::Struct::VanityNameServer>>]
      #
      # @raise  [RequestError] When the request fails.
      def change_domain_delegation_to_vanity(account_id, domain_name, attributes, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation/vanity" % [account_id, domain_name])
        response = client.put(endpoint, attributes, options)

        Dnsimple::Response.new(response, response["data"].map { |r| Struct::VanityNameServer.new(r) })
      end

      # Disable vanity name servers for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/delegation/#dedelegateFromVanity
      #
      # @example Disable vanity name servers for example.com:
      #   client.registrar.change_domain_delegation_from_vanity(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name to check
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def change_domain_delegation_from_vanity(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation/vanity" % [account_id, domain_name])
        response = client.delete(endpoint, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
