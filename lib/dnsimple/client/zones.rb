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
      #   client.zones.list(1010, "example.com", page: 2)
      #
      # @example List zones, provide sorting policy
      #   client.zones.list(1010, "example.com", sort: "name:desc")
      #
      # @example List zones, provide filtering policy
      #   client.zones.list(1010, "example.com", filter: { name_like: "example" })
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Zone>]
      #
      # @raise  [Dnsimple::RequestError]
      def zones(account_id, options = {})
        response = client.get(Client.versioned("/%s/zones" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Zone.new(r) })
      end
      alias list_zones zones

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
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
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
      # @param  [Integer] account_id the account ID
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

      # Gets a zone file from the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/#get-file
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] zone_name the zone name
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneFile>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone_file(account_id, zone_name, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/file" % [account_id, zone_name]), options)

        Dnsimple::Response.new(response, Struct::ZoneFile.new(response["data"]))
      end

    end
  end
end
