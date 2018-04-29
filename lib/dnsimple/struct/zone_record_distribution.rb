module Dnsimple
  module Struct

    class ZoneRecordDistribution < Base
      # @return [Boolean] true if the zone record is properly distributed across
      #         all DNSimple name servers.
      attr_accessor :distributed
    end

  end
end
