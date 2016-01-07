module Dnsimple

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.dnsimple.com/".freeze

    # Default User Agent header
    USER_AGENT   = "dnsimple-ruby/#{VERSION}".freeze

    class << self

      # List of configurable keys for {Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
            :api_endpoint,
            :username,
            :password,
            :domain_api_token,
            :access_token,
            :oauth_client_id,
            :oauth_client_secret,
            :user_agent,
            :proxy,
        ]
      end

      # Configuration options
      # @return [Hash]
      def options
        Hash[keys.map { |key| [key, send(key)]}]
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['DNSIMPLE_API_ENDPOINT'] || API_ENDPOINT
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

      # Default DNSimple Domain API Token for Token Auth from ENV
      # @return [String]
      def domain_api_token
        ENV['DNSIMPLE_API_DOMAIN_TOKEN']
      end

      # Default DNSimple access token for OAuth authentication from ENV
      # @return [String]
      def access_token
        ENV['DNSIMPLE_ACCESS_TOKEN']
      end

      # Default DNSimple OAuth client ID for OAuth authentication from ENV
      # @return [String]
      def oauth_client_id
        ENV['DNSIMPLE_OAUTH_CLIENT_ID']
      end

      # Default DNSimple OAuth client secret for OAuth authentication from ENV
      # @return [String]
      def oauth_client_secret
        ENV['DNSIMPLE_OAUTH_CLIENT_SECRET']
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['DNSIMPLE_USER_AGENT'] || USER_AGENT
      end

      # Default Proxy address:port from ENV
      # @return [String]
      def proxy
        ENV['DNSIMPLE_PROXY']
      end

    end
  end

end
