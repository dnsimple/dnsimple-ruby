# frozen_string_literal: true

module Dnsimple
  module Struct

    class CertificateBundle < Base

      # @return [String] The certificate private key
      attr_accessor :private_key

      # @return [String] The server certificate
      attr_accessor :server

      alias server_certificate server

      # @return [String] The root certificate
      attr_accessor :root

      alias root_certificate root

      # @return [Array<String>] Intermediate certificates
      attr_accessor :chain

      alias intermediate_certificates chain

    end

  end
end
