# frozen_string_literal: true

module Dnsimple
  module Struct
    class Certificate < Base

      # @return [Integer] The certificate ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Integer] The associated contact ID.
      attr_accessor :contact_id

      # @return [String] The certificate common name.
      attr_accessor :common_name

      # @return [Array<String>] The certificate alternate names.
      attr_accessor :alternate_names

      # @return [Integer] The years the certificate will last.
      attr_accessor :years

      # @return [String] The certificate CSR.
      attr_accessor :csr

      # @return [String] The certificate state.
      attr_accessor :state

      # @return [String] The Certificate Authority (CA) that issued the certificate.
      attr_accessor :authority_identifier

      # @return [Boolean] True if the certificate is set to auto-renew on expiration.
      attr_accessor :auto_renew

      # @return [String] When the certificate was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the certificate was last updated in DNSimple.
      attr_accessor :updated_at

      # @return [String] The timestamp when the certificate will expire.
      attr_accessor :expires_at

    end
  end
end
