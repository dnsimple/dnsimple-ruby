# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainRenewal < Base

      # @return [Integer] The domain renewal ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Integer] The number of years the domain was renewed for.
      attr_accessor :period

      # @return [String] The state of the renewal.
      attr_accessor :state

      # @return [String] When the domain renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain renewal was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
