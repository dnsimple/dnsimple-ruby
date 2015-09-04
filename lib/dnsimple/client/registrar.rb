module Dnsimple
  class Client
    module Registrar

      # Checks the availability of a domain name.
      #
      # @see http://developer.dnsimple.com/v1/domains/registry/#check
      #
      # @param  [#to_s] name The domain name to check.
      # @return [Hash] The response containing the status, price, and more details.
      #
      # @raise  [RequestError] When the request fails.
      def check(name, options = {})
        response = begin
          client.get("v1/domains/#{name}/check", options)
        rescue NotFoundError => e
          e.response
        end

        response.parsed_response
      end

      # Checks the availability of a domain name.
      #
      # @see http://developer.dnsimple.com/v1/domains/registry/#check
      #
      # @param  [#to_s] name The domain name to check.
      # @return [Boolean] true if the domain is available
      #
      # @raise  [RequestError] When the request fails.
      def available?(name, options = {})
        check(name, options)["status"] == "available"
      end

      # Registers a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/registry/#register
      #
      # @param  [#to_s] name The domain name to register.
      # @param  [Fixnum] registrant_id The id of the contact to use as registrant.
      # @param  [Hash] extended_attributes
      # @param  [Hash] options
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def register(name, registrant_id, extended_attributes = {}, options = {})
        options = Extra.deep_merge(options, { domain: { name: name, registrant_id: registrant_id }, extended_attribute: extended_attributes })
        response = client.post("v1/domain_registrations", options)

        Struct::Domain.new(response["domain"])
      end

      # Transfers a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/registry/#transfer
      #
      # @param  [#to_s] name The domain name to register.
      # @param  [String] auth_code
      # @param  [Fixnum] registrant_id The id of the contact to use as registrant.
      # @param  [Hash] extended_attributes
      # @param  [Hash] options
      # @return [Struct::TransferOrder]
      #
      # @raise  [RequestError] When the request fails.
      def transfer(name, auth_code, registrant_id, extended_attributes = {}, options = {})
        options = Extra.deep_merge(options, { domain: { name: name, registrant_id: registrant_id }, extended_attribute: extended_attributes, transfer_order: { authinfo: auth_code }})
        response = client.post("v1/domain_transfers", options)

        Struct::TransferOrder.new(response["transfer_order"])
      end

      # Renew a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/registry/#renew
      #
      # @param  [#to_s] name The domain name to renew.
      # @param  [Hash] options
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def renew(name, options = {})
        options = Extra.deep_merge(options, { domain: { name: name }})
        response = client.post("v1/domain_renewals", options)

        Struct::Domain.new(response["domain"])
      end


      # List the extended attributes for a TLD.
      #
      # @see http://developer.dnsimple.com/v1/registrar/extended-attributes/#list
      #
      # @param  [#to_s] tld The TLD name.
      # @return [Array<Struct::ExtendedAttribute>]
      #
      # @raise  [RequestError] When the request fails.
      def extended_attributes(tld, options = {})
        response = client.get("v1/extended_attributes/#{tld}", options)

        response.map { |r| Struct::ExtendedAttribute.new(r) }
      end
      alias :list_extended_attributes :extended_attributes

      # List all the TLD prices.
      #
      # @see http://developer.dnsimple.com/v1/registrar/prices/#list
      #
      # @return [Array<Struct::Price>]
      #
      # @raise  [RequestError] When the request fails.
      def prices(options = {})
        response = client.get("v1/prices", options)

        response.map { |r| Struct::Price.new(r["price"]) }
      end
      alias :list_prices :prices

    end
  end
end
