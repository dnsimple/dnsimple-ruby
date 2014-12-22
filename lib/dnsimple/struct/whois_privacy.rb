module Dnsimple
  module Struct

    class WhoisPrivacy < Base
      # @return [Fixnum] The WHOIS privacy ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated domain ID.
      attr_accessor :domain_id

      # @return [Bool] Whether the WHOIS privacy is enabled.
      attr_accessor :enabled

      # @return [String] The date the domain will expire.
      attr_accessor :expires_on
    end

  end
end
