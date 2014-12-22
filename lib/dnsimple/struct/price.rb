module Dnsimple
  module Struct

    class Price < Base
      attr_accessor :tld
      attr_accessor :minimum_registration
      attr_accessor :registration_price
      attr_accessor :registration_enabled
      attr_accessor :transfer_price
      attr_accessor :transfer_enabled
      attr_accessor :renewal_price
      attr_accessor :renewal_enabled
    end

  end
end
