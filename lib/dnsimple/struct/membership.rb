module Dnsimple
  module Struct

    class Membership < Base
      # @return [Fixnum] The membership ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated domain ID.
      attr_accessor :domain_id

      # @return [Fixnum] The associated user ID.
      attr_accessor :user_id

      # @return [String] When the membership was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the membership was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
