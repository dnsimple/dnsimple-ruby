# frozen_string_literal: true

module Dnsimple
  module Struct
    class Zone < Base

      # @return [Integer] The zone ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated account ID.
      attr_accessor :account_id

      # @return [String] The zone name.
      attr_accessor :name

      # @return [Boolean] True if the zone is a reverse zone.
      attr_accessor :reverse

      # @return [Boolean] True if the zone is a secondary zone.
      attr_accessor :secondary

      # @return [String] When the zone was last transferred from another provider.
      attr_accessor :last_transferred_at

      # @return [Boolean] True if DNS services are active for the zone. False when DNS services are disabled and DNS records will not be resolved
      attr_accessor :active

      # @return [String] When the zone was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the zone was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
