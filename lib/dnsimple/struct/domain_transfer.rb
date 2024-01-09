# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainTransfer < Base

      # @return [Integer] The domain registration ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Integer] The associated registrant (contact) ID.
      attr_accessor :registrant_id

      # @return [String] The state of the renewal.
      attr_accessor :state

      # @return [Bool] True if the domain auto-renew was requested.
      attr_accessor :auto_renew

      # @return [Bool] True if the domain WHOIS privacy was requested.
      attr_accessor :whois_privacy

      # @return [String,nil] The reason if transfer failed.
      attr_accessor :status_description

      # @return [String] When the domain renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain renewal was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
