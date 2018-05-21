module Dnsimple
  class Client
    module ZonesRecords

      # Lists the zone records in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#listZoneRecords
      # @see #all_records
      #
      # @example List records for the zone "example.com" in the first page
      #   client.zones.list_zone_records(1010, "example.com")
      #
      # @example List records for the zone "example.com", provide a specific page
      #   client.zones.list_zone_records(1010, "example.com", page: 2)
      #
      # @example List records for the zone "example.com", sorting in ascending order
      #   client.zones.list_zone_records(1010, "example.com", sort: "type:asc")
      #
      # @example List records for the zone "example.com", filtering by 'A' record type
      #   client.zones.list_zone_records(1010, "example.com", filter: { type: 'A' })
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::ZoneRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone_records(account_id, zone_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records" % [account_id, zone_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::ZoneRecord.new(r) })
      end
      alias list_zone_records zone_records

      # Lists ALL the zone records in the account.
      #
      # This method is similar to {#records}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#listZoneRecords
      # @see #records
      #
      # @example List all records for the zone "example.com"
      #   client.zones.all_zone_records(1010, "example.com")
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::ZoneRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def all_zone_records(account_id, zone_id, options = {})
        paginate(:list_zone_records, account_id, zone_id, options)
      end

      # Creates a zone record in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#createZoneRecord
      #
      # @example Create a URL record in zone "example.com"
      #   client.zones.create_zone_record(1010, "example.com", name: "www", type: "url", content: "example.com")
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def create_zone_record(account_id, zone_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:type, :name, :content])
        response = client.post(Client.versioned("/%s/zones/%s/records" % [account_id, zone_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::ZoneRecord.new(response["data"]))
      end

      # Gets a zone record from the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#getZoneRecord
      #
      # @example Get record 123 in zone "example.com"
      #   client.zones.zone_record(1010, "example.com", 123)
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Integer] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone_record(account_id, zone_id, record_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), options)

        Dnsimple::Response.new(response, Struct::ZoneRecord.new(response["data"]))
      end

      # Updates a zone record in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#updateZoneRecord
      #
      # @example Update the TTL to 600 of record 123 in zone "example.com"
      #   client.zones.update_zone_record(1010, "example.com", 123, ttl: 600)
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Integer] record_id the record ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def update_zone_record(account_id, zone_id, record_id, attributes, options = {})
        response = client.patch(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::ZoneRecord.new(response["data"]))
      end

      # Deletes a zone record from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#deleteZoneRecord
      #
      # @example Delete record 123 in zone "example.com"
      #   client.zones.delete_zone_record(1010, "example.com", 123)
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Integer] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_zone_record(account_id, zone_id, record_id, options = {})
        response = client.delete(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
