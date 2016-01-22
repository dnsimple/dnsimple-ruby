module Dnsimple
  module Struct

    class Zone < Base
      # @return [Fixnum] The zone ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated account ID.
      attr_accessor :account_id

      # @return [String] The zone name.
      attr_accessor :name

      # @return [Boolean] True if the zone is a reverse zone.
      attr_accessor :reverse

      # @return [String] When the zone was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the zone was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
