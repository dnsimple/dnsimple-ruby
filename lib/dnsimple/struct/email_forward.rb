# frozen_string_literal: true

module Dnsimple
  module Struct
    class EmailForward < Base

      # @return [Integer] The email forward ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The "local part" of the originating email address. Anything to the left of the @ symbol.
      # @deprecated use {#alias_email} instead
      attr_accessor :from

      # @return [String] The full email address to forward to.
      # @deprecated use {#destination_email} instead
      attr_accessor :to

      # @return [String] The receiving email recipient.
      attr_accessor :alias_email

      # @return [String] The email recipient the messages are delivered to.
      attr_accessor :destination_email
      # @return [String] Then the email forward was last updated in DNSimple.

      # @return [String] When the email forward was created in DNSimple.
      attr_accessor :created_at

      attr_accessor :updated_at

    end
  end
end
