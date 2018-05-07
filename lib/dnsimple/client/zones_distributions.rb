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

    end
  end
end
