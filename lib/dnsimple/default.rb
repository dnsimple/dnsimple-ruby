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
        keys.to_h { |key| [key, send(key)] }
      end

      # Default API endpoint from ENV or {BASE_URL}
      # @return [String]
      def base_url
        ENV.fetch("DNSIMPLE_BASE_URL", BASE_URL)
      end

      # Default DNSimple username for Basic Auth from ENV
      # @return [String]
      def username
        ENV.fetch("DNSIMPLE_USERNAME", nil)
      end

      # Default DNSimple password for Basic Auth from ENV
      # @return [String]
      def password
        ENV.fetch("DNSIMPLE_PASSWORD", nil)
      end

      # Default DNSimple access token for OAuth authentication from ENV
      # @return [String]
      def access_token
        ENV.fetch("DNSIMPLE_ACCESS_TOKEN", nil)
      end

      # Default DNSimple Domain API Token for Token Auth from ENV
      # @return [String]
      def domain_api_token
        ENV.fetch("DNSIMPLE_API_DOMAIN_TOKEN", nil)
      end

      # Default User-Agent header string from ENV
      # @return [String]
      def user_agent
        ENV.fetch("DNSIMPLE_USER_AGENT", nil)
      end

      # Default Proxy address:port from ENV
      # @return [String]
      def proxy
        ENV.fetch("DNSIMPLE_PROXY", nil)
      end
    end
  end
end
