module Dnsimple
  class Client
    module Domains

      # Lists the domains in the account.
      #
      # @see http://developer.dnsimple.com/v1/domains/#list
      #
      # @param  [Hash] options the filtering and sorting option
      # @return [Array<Struct::Domain>]
      #
      # @raise  [RequestError] When the request fails.
      def domains(options = {})
        response = client.get(Client.versioned("/domains"), options)

        response.map { |r| Struct::Domain.new(r["domain"]) }
      end
      alias :list :domains
      alias :list_domains :domains

      # Creates a domain in the account.
      #
      # @see http://developer.dnsimple.com/v1/domains/#create
      #
      # @param  [Hash] attributes
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def create_domain(attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:name])
        options  = options.merge({ domain: attributes })
        response = client.post(Client.versioned("/domains"), options)

        Struct::Domain.new(response["domain"])
      end
      alias :create :create_domain

      # Gets a domain from the account.
      #
      # @see http://developer.dnsimple.com/v1/domains/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::Domain]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def domain(domain, options = {})
        response = client.get(Client.versioned("/domains/#{domain}"), options)

        Struct::Domain.new(response["domain"])
      end

      # Deletes a domain from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/v1/domains/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_domain(domain, options = {})
        client.delete(Client.versioned("/domains/#{domain}"), options)
      end
      alias :delete :delete_domain

    end
  end
end
