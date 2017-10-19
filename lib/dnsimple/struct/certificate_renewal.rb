module Dnsimple
  module Struct

    class CertificateRenewal < Base
      # @return [Integer] The certificate renewal ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The old certificate ID.
      attr_accessor :old_certificate_id

      # @return [Integer] The new certificate ID.
      attr_accessor :new_certificate_id

      # @return [String] The certificate renewal state.
      attr_accessor :state

      # @return [String] When the certificate renewal was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the certificate renewal was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
