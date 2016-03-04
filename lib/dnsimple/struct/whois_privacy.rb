module Dnsimple
  module Struct

    class WhoisPrivacy < Base
      # @return [Fixnum] The associated domain ID.
      attr_accessor :domain_id

      # @return [Boolean] Whether the whois privacy is enabled for the domain.
      attr_accessor :enabled

      # @return [String] The date the whois privacy will expire on.
      attr_accessor :expires_on

      # @return [String] When the whois privacy was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the whois privacy was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
