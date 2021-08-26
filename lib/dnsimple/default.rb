# frozen_string_literal: true

module Dnsimple

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    BASE_URL = "https://api.dnsimple.com/"

    # Default User Agent header
    USER_AGENT = "dnsimple-ruby/#{VERSION}".freeze

    class << self

      # List of configurable keys for {Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :base_url,
          :username,
          :password,
          :access_token,
          :domain_api_token,
          :user_agent,
          :proxy,
        ]
      end

      # Configuration options
      # @return [Hash]
      def options
        keys.map { |key| [key, send(key)] }.to_h
      end

      # Default API endpoint from ENV or {BASE_URL}
      # @return [String]
      def base_url
        ENV['DNSIMPLE_BASE_URL'] || BASE_URL
      end

      # Default DNSimple username for Basic Auth from ENV
      # @return [String]
      def username
        ENV['DNSIMPLE_USERNAME']
      end

      # Default DNSimple password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['DNSIMPLE_PASSWORD']
      end

      # Default DNSimple access token for OAuth authentication from ENV
      # @return [String]
      def access_token
        ENV['DNSIMPLE_ACCESS_TOKEN']
      end

      # Default DNSimple Domain API Token for Token Auth from ENV
      # @return [String]
      def domain_api_token
        ENV['DNSIMPLE_API_DOMAIN_TOKEN']
      end

      # Default User-Agent header string from ENV
      # @return [String]
      def user_agent
        ENV['DNSIMPLE_USER_AGENT']
      end

      # Default Proxy address:port from ENV
      # @return [String]
      def proxy
        ENV['DNSIMPLE_PROXY']
      end

    end
  end

end
