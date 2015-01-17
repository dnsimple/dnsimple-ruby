module Dnsimple
  class Client
    module Domains

      # Lists the domains in the account.
      #
      # @see http://developer.dnsimple.com/domains/#list
      #
      # @return [Array<Struct::Domain>]
      # @raise  [RequestError] When the request fails.
      def domains(options = {})
        response = client.get("v1/domains", options)

        response.map { |r| Struct::Domain.new(r["domain"]) }
      end

      alias :list :domains

      # Gets a domain from the account.
      #
      # @see http://developer.dnsimple.com/domains/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def domain(domain)
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
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete(domain)
        client.delete("v1/domains/#{domain}")
      end

    end
  end
end
