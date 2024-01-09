# frozen_string_literal: true

module Dnsimple
  module Struct
    class VanityNameServer < Base

      # @return [Integer] The vanity name server ID in DNSimple.
      attr_accessor :id

      # @return [String] The vanity name server name.
      attr_accessor :name

      # @return [String] The vanity name server IPv4.
      attr_accessor :ipv4

      # @return [String] The vanity name server IPv6.
      attr_accessor :ipv6

      # @return [String] When the vanity name server was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the vanity name server was last updated in DNSimple.
      attr_accessor :updated_at

    end
  end
end
