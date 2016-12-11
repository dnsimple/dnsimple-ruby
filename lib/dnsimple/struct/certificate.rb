module Dnsimple
  module Struct

    class Certificate < Base
      # @return [Integer] The certificate ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The certificate common name.
      attr_accessor :common_name

      # @return [Integer] The years the certificate will last.
      attr_accessor :years

      # @return [String] The certificate CSR.
      attr_accessor :csr

      # @return [String] The certificate state.
      attr_accessor :state

      # @return [String] The Certificate Authority (CA) that issued the certificate.
      attr_accessor :authority_identifier

      # @return [String] When the certificate was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the certificate was last updated in DNSimple.
      attr_accessor :updated_at

      # @return [String] When the certificate will expire.
      attr_accessor :expires_on
    end

  end
end
