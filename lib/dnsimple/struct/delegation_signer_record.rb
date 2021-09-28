# frozen_string_literal: true

module Dnsimple
  module Struct

    class DelegationSignerRecord < Base
      # @return [Integer] The ID of the delegation signer record in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The signing algorithm used.
      attr_accessor :algorithm

      # @return [String] The digest value.
      attr_accessor :digest

      # @return [String] The digest type used.
      attr_accessor :digest_type

      # @return [String] The keytag for the associated DNSKEY.
      attr_accessor :keytag

      # @return [String] The public key that references the corresponding DNSKEY record.
      attr_accessor :public_key

      # @return [String] When the delegation signing record was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the delegation signing record was last updated in DNSimple.
      attr_accessor :updated_at

    end

  end
end
