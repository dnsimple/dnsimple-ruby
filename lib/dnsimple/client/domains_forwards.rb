module Dnsimple
  class Client
    module DomainsForwards

      # Lists the email forwards for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/forwards/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Array<Struct::EmailForward>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def email_forwards(domain, options = {})
        response = client.get(Client.versioned("/domains/#{domain}/email_forwards"), options)

        response.map { |r| Struct::EmailForward.new(r["email_forward"]) }
      end
      alias :list_email_forwards :email_forwards

      # Creates an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/forwards/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] attributes
      # @return [Struct::EmailForward]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def create_email_forward(domain, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:from, :to])
        options  = options.merge({ email_forward: attributes })
        response = client.post(Client.versioned("/domains/#{domain}/email_forwards"), options)

        Struct::EmailForward.new(response["email_forward"])
      end

      # Gets an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/forwards/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] forward The forward id.
      # @return [Struct::EmailForward]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def email_forward(domain, forward, options = {})
        response = client.get(Client.versioned("/domains/#{domain}/email_forwards/#{forward}"), options)

        Struct::EmailForward.new(response["email_forward"])
      end

      # Deletes an email forward for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/forwards/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] forward The forward id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_email_forward(domain, forward, options = {})
        client.delete(Client.versioned("/domains/#{domain}/email_forwards/#{forward}"), options)
      end

    end
  end
end
