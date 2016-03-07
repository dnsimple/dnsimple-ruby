module Dnsimple
  class Client
    module Zones

      # Lists the zones in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/#list
      # @see #all_zones
      #
      # @example List zones in the first page
      #   client.zones.list(1010, "example.com")
      #
      # @example List zones, provide a specific page
      #   client.zones.list(1010, "example.com", query: { page: 2 })
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Zone>]
      #
      # @raise  [Dnsimple::RequestError]
      def zones(account_id, options = {})
        response = client.get(Client.versioned("/%s/zones" % [account_id]), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Zone.new(r) })
      end
      alias :list :zones
      alias :list_zones :zones

      # Lists ALL the zones in the account.
      #
      # This method is similar to {#zones}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/zones/#list
      # @see #zones
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Zone>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_zones(account_id, options = {})
        paginate(:zones, account_id, options)
      end

      # Gets a zone from the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/#get
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [#to_s] zone_id the zone name
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Zone>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone(account_id, zone_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s" % [account_id, zone_id]), options)

        Dnsimple::Response.new(response, Struct::Zone.new(response["data"]))
      end

    end
  end
end
