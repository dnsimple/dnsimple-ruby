# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainPrice < Base
      # @return [String] The domain name
      attr_accessor :domain

      # @return [Boolean] Whether the domain is premium.
      attr_accessor :premium

      # @return [Float] The price for registration
      attr_accessor :registration_price

      # @return [Float] The price for renewal
      attr_accessor :renewal_price

      # @return [Float] The price for transfer
      attr_accessor :transfer_price

      # @return [Float] The Trustee service price
      attr_accessor :trustee_service_price
    end
  end
end
