module Dnsimple
  class Client
    module Domains

      # Lists the domains in the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#list
      # @see #all_domains
      #
      # @example List domains in the first page
      #   client.domains(1010)
      #
      # @example List domains, provide a specific page
      #   client.domains(1010, query: { page: 2 })
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Array<Dnsimple::Struct::Domain>]
      # @raise  [Dnsimple::RequestError] when the request fails.
      def domains(account_id, options = {})
        response = client.get(Client.versioned("/%s/domains" % [account_id]), options)

        PaginatedResponse.new(response, response["data"].map { |r| Struct::Domain.new(r) })
      end
      alias :list :domains
      alias :list_domains :domains

      # Lists ALL the domains in the account.
      #
      # This method is similar to {#domains}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/domains/#list
      # @see #domains
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Array<Dnsimple::Struct::Domain>]
      # @raise  [Dnsimple::RequestError] when the request fails.
      def all_domains(account_id, options = {})
        client.paginate(self, :domains, account_id, options)
      end
      alias :all :all_domains

      # Gets a domain from the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#get
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::Domain]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def domain(account_id, domain, options = {})
        response = client.get(Client.versioned("/%s/domains/%s" % [account_id, domain]), options)

        Struct::Domain.new(response["data"])
      end

    end
  end
end