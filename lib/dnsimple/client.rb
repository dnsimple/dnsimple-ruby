require 'dnsimple/extra'
require 'dnsimple/struct'
require 'dnsimple/response'
require 'dnsimple/client/clients'

module Dnsimple

  # Client for the DNSimple API
  #
  # @see http://developer.dnsimple.com
  class Client

    HEADER_DOMAIN_API_TOKEN = "X-DNSimple-Domain-Token"
    HEADER_AUTHORIZATION = "Authorization"
    WILDCARD_ACCOUNT = "_"


    # @return [String] The current API version.
    API_VERSION = "v2"


    # Prepends the correct API version to +path+.
    #
    # @return [String] The versioned path.
    def self.versioned(path)
      File.join(API_VERSION, path)
    end


    # @!attribute username
    #   @see https://developer.dnsimple.com/v2/#authentication
    #   @return [String] DNSimple username for Basic Authentication
    # @!attribute password
    #   @see https://developer.dnsimple.com/v2/#authentication
    #   @return [String] DNSimple password for Basic Authentication
    # @!attribute domain_api_token
    #   @see https://developer.dnsimple.com/v2/#authentication
    #   @return [String] Domain API access token for authentication
    # @!attribute access_token
    #   @see https://developer.dnsimple.com/v2/#authentication
    #   @return [String] Domain API access token for authentication
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. (default: https://api.dnsimple.com/)
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.
    # @!attribute proxy
    #   @return [String,nil] Configure address:port values for proxy server

    attr_accessor :username, :password, :domain_api_token, :access_token,
                  :api_endpoint, :user_agent, :proxy


    def initialize(options = {})
      defaults = Dnsimple::Default.options

      Dnsimple::Default.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || defaults[key])
      end

      @services = {}
    end


    # @return [String] Base URL for API requests.
    def api_endpoint
      Extra.join_uri(@api_endpoint, "")
    end


    # Make a HTTP GET request.
    #
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Query and header params for request
    # @return [HTTParty::Response]
    def get(path, options = {})
      execute :get, path, options
    end

    # Make a HTTP POST request.
    #
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Body and header params for request
    # @return [HTTParty::Response]
    def post(path, options = {})
      execute :post, path, options
    end

    # Make a HTTP PUT request.
    #
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Body and header params for request
    # @return [HTTParty::Response]
    def put(path, options = {})
      execute :put, path, options
    end

    # Make a HTTP DELETE request.
    #
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Query and header params for request
    # @return [HTTParty::Response]
    def delete(path, options = {})
      execute :delete, path, options
    end

    # Executes a request, validates and returns the response.
    #
    # @param  [String] method The HTTP method
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Query and header params for request
    # @return [HTTParty::Response]
    # @raise  [RequestError]
    # @raise  [NotFoundError]
    # @raise  [AuthenticationFailed]
    # @raise  [TwoFactorAuthenticationRequired]
    def execute(method, path, data, options = {})
      response = request(method, path, data, options)

      case response.code
      when 200..299
        response
      when 401
        raise AuthenticationFailed.new(response["message"])
      when 404
        raise NotFoundError.new(response)
      else
        raise RequestError.new(response)
      end
    end

    # Make a HTTP request.
    #
    # This method doesn't validate the response and never raise errors
    # even in case of HTTP error codes, except for connection errors raised by
    # the underlying HTTP client.
    #
    # Therefore, it's up to the caller to properly handle and validate the response.
    #
    # @param  [String] method The HTTP method
    # @param  [String] path The path, relative to {#api_endpoint}
    # @param  [Hash] options Query and header params for request
    # @return [HTTParty::Response]
    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query)   if data.key?(:query)
        options[:headers] = data.delete(:headers) if data.key?(:headers)
      end
      if !data.empty?
        options[:body] = data
      end

      HTTParty.send(method, api_endpoint + path, Extra.deep_merge!(base_options, options))
    end


    private

    def base_options
      options = {
          format:   :json,
          headers:  { 'Accept' => 'application/json', 'User-Agent' => user_agent },
      }

      if proxy
        address, port = proxy.split(":")
        options.merge!(http_proxyaddr: address, http_proxyport: port)
      end

      if password
        options[:basic_auth] = { username: username, password: password }
      elsif domain_api_token
        options[:headers][HEADER_DOMAIN_API_TOKEN] = domain_api_token
      elsif access_token
        options[:headers][HEADER_AUTHORIZATION] = "Bearer #{access_token}"
      else
        raise Error, 'A password, domain  API token or OAuth access token is required for all API requests.'
      end

      options
    end

  end
end
