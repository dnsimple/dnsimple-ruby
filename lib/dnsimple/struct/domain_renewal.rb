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

      # @return [Bool] True if the domain WHOIS privacy was requested to be renewed.
      attr_accessor :private_whois

      # @return [String] The premium price requested for the renewal.
      attr_accessor :premium_price

      # @return [String] When the domain renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain renewal was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
