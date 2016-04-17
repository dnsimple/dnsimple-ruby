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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Hash] options
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Array] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Array>]
      #
      # @raise  [RequestError] When the request fails.
      def change_domain_delegation(account_id, domain_name, attributes, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation" % [account_id, domain_name])
        response = client.put(endpoint, attributes, options)

        Dnsimple::Response.new(response, response["data"])
      end

    end
  end
end
