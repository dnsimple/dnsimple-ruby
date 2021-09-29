# frozen_string_literal: true

module Dnsimple
  module Struct

    class Tld < Base
      # @return [String] The TLD in DNSimple.
      attr_accessor :tld

      # @return [Integer] The TLD type.
      attr_accessor :tld_type

      # @return [Boolean] True if Whois Privacy Protection is available.
      attr_accessor :whois_privacy

      # @return [Boolean] True if TLD requires use of auto-renewal for renewals.
      attr_accessor :auto_renew_only

      # @return [Boolean] True if IDN is available.
      attr_accessor :idn

      # @return [Integer] The minimum registration period, in years.
      attr_accessor :minimum_registration

      # @return [Boolean] True if DNSimple supports registrations for this TLD.
      attr_accessor :registration_enabled

      # @return [Boolean] True if DNSimple supports renewals for this TLD.
      attr_accessor :renewal_enabled

      # @return [Boolean] True if DNSimple supports inbound transfers for this TLD.
      attr_accessor :transfer_enabled

      # @return [String, nil] Type of data interface required for DNSSEC for this TLD.
      attr_accessor :dnssec_interface_type
    end

  end
end
