module Dnsimple
  class Client
    class DomainsService < ClientService

      # Lists the domains in the account.
      #
      # @see http://developer.dnsimple.com/domains/#list
      #
      # @return [Array<Struct::Domain>]
      # @raise  [RequestError] When the request fails.
      def list(options = {})
        response = client.get("v1/domains", options)

        response.map { |r| Struct::Domain.new(r["domain"]) }
      end

      # Gets a domain from the account.
      #
      # @see http://developer.dnsimple.com/domains/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(domain)
        response = client.get("v1/domains/#{domain}")

        Struct::Domain.new(response["domain"])
      end

      # Creates a domain in the account.
      #
      # @see http://developer.dnsimple.com/domains/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name])
        options  = { domain: attributes }
        response = client.post("v1/domains", options)

        Struct::Domain.new(response["domain"])
      end

      # Deletes a domain from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/domains/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete(domain)
        client.delete("v1/domains/#{domain}")
      end


      # Enables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/domains/autorenewal/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def enable_auto_renewal(domain)
        response = client.post("v1/domains/#{domain}/auto_renewal")

        Struct::Domain.new(response["domain"])
      end

      # Disables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/domains/autorenewal/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def disable_auto_renewal(domain)
        response = client.delete("v1/domains/#{domain}/auto_renewal")

        Struct::Domain.new(response["domain"])
      end


      # Lists the email forwards for a domain.
      #
      # @see http://developer.dnsimple.com/domains/forwards/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] options
      #
      # @return [Array<Struct::EmailForward>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list_email_forwards(domain)
        response = client.get("v1/domains/#{domain}/email_forwards")

        response.map { |r| Struct::EmailForward.new(r["email_forward"]) }
      end

      # Creates an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/domains/forwards/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] attributes
      #
      # @return [Struct::EmailForward]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def create_email_forward(domain, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:from, :to])
        options  = { email_forward: attributes }
        response = client.post("v1/domains/#{domain}/email_forwards", options)

        Struct::EmailForward.new(response["email_forward"])
      end

      # Gets an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/domains/forwards/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] forward The forward id.
      #
      # @return [Struct::EmailForward]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find_email_forward(domain, forward)
        response = client.get("v1/domains/#{domain}/email_forwards/#{forward}")

        Struct::EmailForward.new(response["email_forward"])
      end

      # Deletes an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/domains/forwards/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] forward The forward id.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete_email_forward(domain, forward)
        client.delete("v1/domains/#{domain}/email_forwards/#{forward}")
      end


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
        rescue RecordNotFound
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


      def extended_attributes(tld, options={})
        response = Client.get("v1/extended_attributes/#{tld}", options)

        response.map { |r| Struct::ExtendedAttribute.new(r) }
      end

    end
  end
end
