# frozen_string_literal: true

module Dnsimple
  module Struct

    class DomainRegistration < Base
      # @return [Integer] The domain registration ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Integer] The associated registrant (contact) ID.
      attr_accessor :registrant_id

      # @return [Integer] The number of years the domain was registered for.
      attr_accessor :period

      # @return [String] The state of the renewal.
      attr_accessor :state

      # @return [Bool] True if the domain auto-renew was requested.
      attr_accessor :auto_renew

      # @return [Bool] True if the domain WHOIS privacy was requested.
      attr_accessor :whois_privacy

      # @return [String] When the domain renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain renewal was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
