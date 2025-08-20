# frozen_string_literal: true

module Dnsimple
  module Struct
    class EmailForward < Base

      # @return [Integer] The email forward ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The receiving email recipient.
      attr_accessor :alias_email

      # @return [String] The email recipient the messages are delivered to.
      attr_accessor :destination_email

      # @return [Boolean] True if the email forward is active, false otherwise.
      attr_accessor :active

      # @return [String] When the email forward was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the email forward was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
