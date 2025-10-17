# frozen_string_literal: true

module Dnsimple
  module Struct
    class CertificatePurchase < Base
      # @return [Integer] The certificate purchase ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The certificate ID.
      attr_accessor :certificate_id

      # @return [String] The certificate renewal state.
      attr_accessor :state

      # @return [Boolean] True if the certificate is requested to auto-renew
      attr_accessor :auto_renew

      # @return [String] When the certificate renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the certificate renewal was last updated in DNSimple.
      attr_accessor :updated_at
    end
  end
end
