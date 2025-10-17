# frozen_string_literal: true

module Dnsimple
  module Struct
    class ZoneRecordsBatchChange < Base
      # @return [Array<ZoneRecord>]
      attr_accessor :creates

      # @return [Array<ZoneRecord>]
      attr_accessor :updates

      # @return [Array<ZoneRecordId>]
      attr_accessor :deletes
    end
  end
end
