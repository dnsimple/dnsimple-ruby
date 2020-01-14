# frozen_string_literal: true

module Dnsimple
  module Struct

    class Domain < Base
      # @return [Integer] The domain ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated account ID.
      attr_accessor :account_id

      # @return [Integer] The associated registrant (contact) ID.
      attr_accessor :registrant_id

      # @return [String] The domain name.
      attr_accessor :name

      # @return [String] The domain API token used for domain authentication.
      attr_accessor :token

      # @return [String] The domain state.
      attr_accessor :state

      # @return [Bool] True if the domain is set to auto-renew, false otherwise.
      attr_accessor :auto_renew

      # @return [Bool] True if the domain WHOIS privacy is enabled, false otherwise.
      attr_accessor :private_whois

      # @return [String] The date the domain will expire.
      attr_accessor :expires_on

      # @return [String] When the domain was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
