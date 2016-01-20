module Dnsimple
  module Struct

    class Record < Base
      # @return [Fixnum] The record ID in DNSimple.
      attr_accessor :id

      # @return [String] The associated zone ID.
      attr_accessor :zone_id

      # @return [Fixnum] The ID of the parent record, if this record is dependent on another record.
      attr_accessor :parent_id

      # @return [String] The type of record, in uppercase.
      attr_accessor :type

      # @return [String] The record name (without the domain name).
      attr_accessor :name

      # @return [String] The plain-text record content.
      attr_accessor :content

      # @return [Fixnum] The TTL value.
      attr_accessor :ttl

      # @return [Fixnum] The priority value, if the type of record accepts a priority.
      attr_accessor :priority

      # @return [Bool] True if this is a system record created by DNSimple. System records are read-only.
      attr_accessor :system_record

      # @return [String] When the domain was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the domain was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
