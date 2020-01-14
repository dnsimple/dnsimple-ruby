# frozen_string_literal: true

module Dnsimple
  module Struct

    class ZoneFile < Base
      # @return [String] The zone file contents.
      attr_accessor :zone
    end

  end
end
