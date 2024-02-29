# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainRestore < Base

      # @return [Integer] The domain restore ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The state of the restore.
      attr_accessor :state

      # @return [String] When the domain restore was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain restore was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
