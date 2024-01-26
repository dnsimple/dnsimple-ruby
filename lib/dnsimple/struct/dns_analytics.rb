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

      def self.from(attributes)
        attributes.each do |key, value|
          if key == 'data'
            # cocotero
          else
            m = :"#{key}="
            send(m, value) if respond_to?(m)
          end
        end
      end

    end
  end
end
