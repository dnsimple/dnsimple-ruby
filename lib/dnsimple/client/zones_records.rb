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
      #
      # @raise  [Dnsimple::RequestError]
      def records(account_id, zone_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records" % [account_id, zone_id]), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Record.new(r) })
      end
      alias list_records records

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
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Record>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_records(account_id, zone_id, options = {})
        paginate(:records, account_id, zone_id, options)
      end

      # Creates a zone record in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#create
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Record>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_record(account_id, zone_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:type, :name, :content])
        response = client.post(Client.versioned("/%s/zones/%s/records" % [account_id, zone_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Record.new(response["data"]))
      end

      # Gets a zone record from the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#get
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Fixnum] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Domain>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def record(account_id, zone_id, record_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), options)

        Dnsimple::Response.new(response, Struct::Record.new(response["data"]))
      end

      # Updates a zone record in the account.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#update
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Fixnum] record_id the record ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Record>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def update_record(account_id, zone_id, record_id, attributes, options = {})
        response = client.patch(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Record.new(response["data"]))
      end

      # Deletes a zone record from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#delete
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] zone_id the zone name
      # @param  [Fixnum] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_record(account_id, zone_id, record_id, options = {})
        response = client.delete(Client.versioned("/%s/zones/%s/records/%s" % [account_id, zone_id, record_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
