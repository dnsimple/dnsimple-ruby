# frozen_string_literal: true

module Dnsimple
  module Struct
    class RegistrantChange < Base

      # @return [Integer] The registrant change ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated account ID.
      attr_accessor :account_id

      # @return [Integer] The associated contact ID.
      attr_accessor :contact_id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The registrant change state.
      attr_accessor :state

      # @return [Hash] The extended attributes.
      attr_accessor :extended_attributes

      # @return [Boolean] True if the registrant change is a registry owner change.
      attr_accessor :registry_owner_change

      # @return [String] When the Inter-Registrar Transfer lock (60 days) is going to be lifted.
      attr_accessor :irt_lock_lifted_by

      # @return [String] When the registrant change was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the registrant change was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
