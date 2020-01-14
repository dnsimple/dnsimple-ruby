# frozen_string_literal: true

module Dnsimple
  module Struct

    class WhoisPrivacyRenewal < Base
      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Integer] The associated WHOIS Privacy ID.
      attr_accessor :whois_privacy_id

      # @return [String] The WHOIS Privacy order state.
      attr_accessor :state

      # @return [Boolean] Whether the WHOIS Privacy is enabled for the domain.
      attr_accessor :enabled

      # @return [String] The date the WHOIS Privacy will expire on.
      attr_accessor :expires_on

      # @return [String] When the WHOIS Privacy was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the WHOIS Privacy was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
