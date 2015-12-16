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
      # @return [Array<Struct::Domain>]
      # @raise  [RequestError] When the request fails.
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
      # @return [Array<Struct::Domain>]
      # @raise  [RequestError] When the request fails.
      def all_domains(account_id, options = {})
        current_page = 0
        total_pages  = nil
        collection   = []

        begin
          current_page += 1
          query = Extra.deep_merge(options, query: { page: current_page, per_page: 100 })

          response = domains(account_id, query)
          total_pages ||= response.total_pages
          collection.concat(response)
        end while current_page < total_pages

        collection
      end
      alias :all :all_domains

    end
  end
end