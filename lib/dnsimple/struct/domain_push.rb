module Dnsimple
  module Struct

    class DomainPush < Base
      # @return [Fixnum] The domain push ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated domain ID.
      attr_accessor :domain_id

      # @return [Fixnum] The associated contact ID.
      attr_accessor :contact_id

      # @return [Fixnum] The associated account ID.
      attr_accessor :account_id

      # @return [String] When the domain push was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain push was last updated in DNSimple.
      attr_accessor :updated_at

      # @return [String] When the domain push was accepted in DNSimple.
      attr_accessor :accepted_at
    end

  end
end
