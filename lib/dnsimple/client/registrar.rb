module Dnsimple
  class Client
    module Registrar

      # Checks whether a domain is available to be registered.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#check
      #
      # @example Check whether example.com is available:
      #   client.registrar.check(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to check.
      # @param  [Hash] options
      # @return [Struct::DomainCheck]
      #
      # @raise  [RequestError] When the request fails.
      def check(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/check" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::DomainCheck.new(response["data"]))
      end

      # Registers a domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#register
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to register.
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def register(account_id, domain_name, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:registrant_id])
        endpoint = Client.versioned("/%s/registrar/domains/%s/registration" % [account_id, domain_name])
        response = client.post(endpoint, options.merge(attributes))

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end

      # Starts the transfer of a domain to DNSimple.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#transfer
      #
      # @example Initiate the transfer for example.com using the contact 1234 as registrant:
      #   client.registrar.transfer(1010, "example.com", registrant_id: 1234, auth_info: "x1y2z3")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to transfer.
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def transfer(account_id, domain_name, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:registrant_id])
        endpoint = Client.versioned("/%s/registrar/domains/%s/transfer" % [account_id, domain_name])
        response = client.post(endpoint, options.merge(attributes))

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end

      def transfer_out(account_id, domain_name, attributes = {}, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/transfer_out" % [account_id, domain_name])
        response = client.post(endpoint, options.merge(attributes))

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
