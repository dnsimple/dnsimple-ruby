module Dnsimple
  module Struct

    class Domain < Base
      # @return [Fixnum] The domain ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated user ID.
      attr_accessor :user_id

      # @return [Fixnum] The associated registrant (contact) ID.
      attr_accessor :registrant_id

      # The String name.
      attr_accessor :name

      # The String state.
      attr_accessor :state

      # The String API token
      attr_accessor :token

      # Is the domain set to auto renew?
      attr_accessor :auto_renew

      # Is the whois information protected?
      attr_accessor :whois_protected

      # @return [String] The date the domain will expire.
      attr_accessor :expires_on

      # @return [String] When the domain was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
