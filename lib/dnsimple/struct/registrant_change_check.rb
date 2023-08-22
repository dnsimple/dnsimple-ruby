# frozen_string_literal: true

module Dnsimple
  module Struct

    class RegistrantChangeCheck < Base
      # @return [Integer] The associated contact ID.
      attr_accessor :contact_id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [Array<Hash>] The extended attributes.
      attr_accessor :extended_attributes

      # # @return [Boolean] True if the registrant change is a registry owner change.
      attr_accessor :registry_owner_change
    end
  end
end
