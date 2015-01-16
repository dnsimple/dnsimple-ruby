module Dnsimple
  class Client
    module Registrar

      # Checks the availability of a domain name.
      #
      # @see http://developer.dnsimple.com/domains/registry/#check
      #
      # @param  [#to_s] name The domain name to check.
      #
      # @return [String] "available" or "registered"
      # @raise  [RequestError] When the request fails.
      def check(name, options={})
        begin
          client.get("v1/domains/#{name}/check", options)
          "registered"
        rescue NotFoundError
          "available"
        end
      end

      # Registers a domain.
      #
      # @see http://developer.dnsimple.com/domains/registry/#register
      #
      # @param  [#to_s] name The domain name to register.
      # @param  [Fixnum] registrant_id The id of the contact to use as registrant.
      # @param  [Hash] extended_attributes
      # @param  [Hash] options
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def register(name, registrant_id, extended_attributes = {}, options = {})
        options = Extra.deep_merge(options, { domain: { name: name, registrant_id: registrant_id }, extended_attribute: extended_attributes })
        response = client.post("v1/domain_registrations", options)

        Struct::Domain.new(response["domain"])
      end

      # Transfers a domain.
      #
      # @see http://developer.dnsimple.com/domains/registry/#transfer
      #
      # @param  [#to_s] name The domain name to register.
      # @param  [String] auth_code
      # @param  [Fixnum] registrant_id The id of the contact to use as registrant.
      # @param  [Hash] extended_attributes
      # @param  [Hash] options
      #
      # @return [Struct::TransferOrder]
      # @raise  [RequestError] When the request fails.
      def transfer(name, auth_code, registrant_id, extended_attributes = {}, options = {})
        options = Extra.deep_merge(options, { domain: { name: name, registrant_id: registrant_id }, extended_attribute: extended_attributes, transfer_order: { authinfo: auth_code }})
        response = client.post("v1/domain_transfers", options)

        Struct::TransferOrder.new(response["transfer_order"])
      end

      # Renew a domain.
      #
      # @see http://developer.dnsimple.com/domains/registry/#renew
      #
      # @param  [#to_s] name The domain name to renew.
      # @param  [Hash] options
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def renew(name, options = {})
        options = Extra.deep_merge(options, { domain: { name: name }})
        response = client.post("v1/domain_renewals", options)

        Struct::Domain.new(response["domain"])
      end


      # List the extended attributes for a TLD.
      #
      # @see http://developer.dnsimple.com/registrar/extended-attributes/#list
      #
      # @param  [#to_s] tld The TLD name.
      #
      # @return [Array<Struct::ExtendedAttribute>]
      # @raise  [RequestError] When the request fails.
      def list_extended_attributes(tld)
        response = client.get("v1/extended_attributes/#{tld}")

        response.map { |r| Struct::ExtendedAttribute.new(r) }
      end


      # List all the TLD prices.
      #
      # @see http://developer.dnsimple.com/registrar/prices/#list
      #
      # @return [Array<Struct::Price>]
      # @raise  [RequestError] When the request fails.
      def list_prices
        response = client.get("v1/prices")

        response.map { |r| Struct::Price.new(r["price"]) }
      end

    end
  end
end
