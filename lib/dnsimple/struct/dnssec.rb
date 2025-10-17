# frozen_string_literal: true

module Dnsimple
  module Struct
    class Dnssec < Base
      # @return [Boolean] True if DNSSEC is enabled on the domain, otherwise false
      attr_accessor :enabled
    end
  end
end
