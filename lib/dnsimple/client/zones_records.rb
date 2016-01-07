module Dnsimple
  class Client
    module ZonesRecords

      # Lists the zone records in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#list
      # @see #all_records
      #
      # @example List records for the zone "example.com" in the first page
      #   client.zones.records(1010, "example.com")
      #
      # @example List records for the zone "example.com", provide a specific page
      #   client.zones.records(1010, "example.com", query: { page: 2 })
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Record>]
      # @raise  [Dnsimple::RequestError]
      def records(account_id, zone_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records" % [account_id, zone_id]), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Record.new(r) })
      end
      alias :list_records :records

      # Lists ALL the zone records in the account.
      #
      # This method is similar to {#records}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#list
      # @see #records
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Record>]
      # @raise  [Dnsimple::RequestError]
      def all_records(account_id, zone_id, options = {})
        paginate(:records, account_id, zone_id, options)
      end

    end
  end
end
