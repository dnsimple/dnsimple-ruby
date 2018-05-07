module Dnsimple
  class Client
    module ZonesDistributions

      # Check if a zone is fully distributed across all DNSimple name servers.
      #
      # @see https://developer.dnsimple.com/v2/zones/#checkZoneDistribution
      #
      # @param  account_id [Integer] the account ID
      # @param  zone_id [#to_s] the zone name
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneDistribution>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone_distribution(account_id, zone_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/distribution" % [account_id, zone_id]), options)

        Dnsimple::Response.new(response, Struct::ZoneDistribution.new(response["data"]))
      end

      # Gets a zone record distribution state
      #
      # @see https://developer.dnsimple.com/v2/zones/records/#checkZoneRecordDistribution
      #
      # @example Get record 123 in zone "example.com"
      #   client.zones.zone_record_distribution(1010, "example.com", 123)
      #
      # @param  [Integer] account_id the account ID
      # @param  [String] zone_id the zone name
      # @param  [Integer] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::ZoneRecordDistribution>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def zone_record_distribution(account_id, zone_id, record_id, options = {})
        response = client.get(Client.versioned("/%s/zones/%s/records/%s/distribution" % [account_id, zone_id, record_id]), options)

        Dnsimple::Response.new(response, Struct::ZoneRecordDistribution.new(response["data"]))
      end

    end
  end
end
