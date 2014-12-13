require 'dnsimple/version'

module Dnsimple
  class Client

    DEFAULT_BASE_URI = "https://api.dnsimple.com/"
    HEADER_2FA_STRICT = "X-DNSimple-2FA-Strict"
    HEADER_API_TOKEN = "X-DNSimple-Token"
    HEADER_DOMAIN_API_TOKEN = "X-DNSimple-Domain-Token"
    HEADER_OTP_TOKEN = "X-DNSimple-OTP"
    HEADER_EXCHANGE_TOKEN = "X-DNSimple-OTP-Token"

    class << self
      # @return [Boolean] if the debug mode is enabled.
      #   Defaults to false.
      attr_accessor :debug

      attr_accessor :username, :password, :exchange_token, :api_token, :domain_api_token
    end

    # Gets the qualified API base uri.
    #
    # @return [String] The qualified API base uri.
    def self.base_uri
      @base_uri ||= DEFAULT_BASE_URI.chomp("/")
    end

    # Sets the qualified API base uri.
    #
    # @param [String] value The qualified API base uri.
    def self.base_uri=(value)
      @base_uri = value.to_s.chomp("/")
    end

    def self.http_proxy
      @http_proxy
    end

    def self.base_options
      options = {
        :format => :json,
        :headers => { 'Accept' => 'application/json', 'User-Agent' => "dnsimple-ruby/#{VERSION}" },
      }

      if http_proxy
        options.merge!(
          :http_proxyaddr => http_proxy[:addr],
          :http_proxyport => http_proxy[:port]
        )
      end

      if exchange_token
        options[:basic_auth] = { :username => exchange_token, :password => "x-2fa-basic" }
      elsif password
        options[:basic_auth] = { :username => username, :password => password }
      elsif domain_api_token
        options[:headers][HEADER_DOMAIN_API_TOKEN] = domain_api_token
      elsif api_token
        options[:headers][HEADER_API_TOKEN] = "#{username}:#{api_token}"
      else
        raise Error, 'A password or API token is required for all API requests.'
      end

      options
    end

    def self.get(path, options = {})
      request :get, path, options
    end

    def self.post(path, options = {})
      request :post, path, options
    end

    def self.put(path, options = {})
      request :put, path, options
    end

    def self.delete(path, options = {})
      request :delete, path, options
    end

    def self.request(method, path, options)
      response = HTTParty.send(method, "#{base_uri}#{path}", base_options.merge(options))

      if response.code == 401 && response.headers[HEADER_OTP_TOKEN] == "required"
        raise TwoFactorAuthenticationRequired, response["message"]
      elsif response.code == 401
        raise AuthenticationFailed, response["message"]
      end

      response
    end

  end
end
