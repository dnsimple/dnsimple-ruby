module Dnsimple
  class Client
    module DomainsForwards

      # Lists the email forwards for a domain.
      #
      # @see http://developer.dnsimple.com/domains/forwards/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Array<Struct::EmailForward>]
      # @raise  [NotFoundError]
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
      # @raise  [NotFoundError]
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
      # @raise  [NotFoundError]
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
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_email_forward(domain, forward)
        client.delete("v1/domains/#{domain}/email_forwards/#{forward}")
      end

    end
  end
end
