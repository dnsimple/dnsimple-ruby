# frozen_string_literal: true

module Dnsimple
  module Struct
    class ZoneDistribution < Base

      # @return [Boolean] true if the zone is properly distributed across
      #         all DNSimple name servers.
      attr_accessor :distributed

    end
  end
end
