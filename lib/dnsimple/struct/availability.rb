module Dnsimple
  module Struct

    class Availability < Base
      # @return [String] The domain name that was checked.
      attr_accessor :domain

      # @return [Boolean] Whether the domain name is available.
      attr_accessor :available

      # @return [Boolean] Whether the domain name is premium.
      attr_accessor :premium
    end

  end
end
