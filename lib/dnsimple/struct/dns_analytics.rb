# frozen_string_literal: true

module Dnsimple
  module Struct
    class DnsAnalytics < Base

      # @return [Integer] The recorded volume
      attr_accessor :volume

      # @return [Date] The date
      attr_accessor :date

      # @return [String] The zone name
      attr_accessor :zone

    end
  end
end
