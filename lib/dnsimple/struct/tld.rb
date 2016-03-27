module Dnsimple
  module Struct

    class Tld < Base
      # @return [String] The TLD in DNSimple.
      attr_accessor :tld

      # @return [Fixnum] The TLD type.
      attr_accessor :tld_type

      # @return [Boolean] True if Whois Privacy Protection is available.
      attr_accessor :whois_privacy

      # @return [Boolean] True if TLD requires use of auto-renewal for renewals.
      attr_accessor :auto_renew_only

      # @return [Boolean] True if IDN is available.
      attr_accessor :idn
    end

  end
end
