require 'httparty'
require 'dnsimple/extra'
require 'dnsimple/struct'
require 'dnsimple/response'
require 'dnsimple/client/clients'

module Dnsimple

  # Client for the DNSimple API
  #
  # @see https://developer.dnsimple.com/
  class Client

    HEADER_AUTHORIZATION = "Authorization".freeze
    WILDCARD_ACCOUNT = "_".freeze


    # @return [String] The current API version.
    API_VERSION = "v2".freeze


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
    # @!attribute base_url
    #   @return [String] Base URL for API requests. (default: https://api.dnsimple.com/)
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.
    # @!attribute proxy
    #   @return [String,nil] Configure address:port values for proxy server

    attr_accessor :username, :password, :domain_api_token, :access_token,
                  :base_url, :user_agent, :proxy


    def initialize(options = {})
      defaults = Dnsimple::Default.options

      Dnsimple::Default.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || defaults[key])
      end

      @services = {}
    end


    # @return [String] Base URL for API requests.
    def base_url
      Extra.join_uri(@base_url, "")
    end


    # Make a HTTP GET request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def get(path, options = {})
      execute :get, path, nil, options
    end

    # Make a HTTP POST request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] data The body for the request
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def post(path, data = nil, options = {})
      execute :post, path, data, options
    end

    # Make a HTTP PUT request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] data The body for the request
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def put(path, data = nil, options = {})
      execute :put, path, data, options
    end

    # Make a HTTP PATCH request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] data The body for the request
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def patch(path, data = nil, options = {})
      execute :patch, path, data, options
    end

    # Make a HTTP DELETE request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def delete(path, data = nil, options = {})
      execute :delete, path, data, options
    end

    # Executes a request, validates and returns the response.
    #
    # @param  [String] method The HTTP method
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] data The body for the request
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    # @raise  [RequestError]
    # @raise  [NotFoundError]
    # @raise  [AuthenticationFailed]
    # @raise  [TwoFactorAuthenticationRequired]
    def execute(method, path, data = nil, options = {})
      response = request(method, path, data, options)

      case response.code
      when 200..299
        response
      when 401
        raise AuthenticationFailed, response["message"]
      when 404
        raise NotFoundError, response
      else
        raise RequestError, response
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
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] data The body for the request
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def request(method, path, data = nil, options = {})
      request_options = request_options(options)

      if data
        request_options[:headers]["Content-Type"] = content_type(request_options[:headers])
        request_options[:body] = content_data(request_options[:headers], data)
      end

      HTTParty.send(method, base_url + path, request_options)
    end


    private

    def request_options(custom_options = {})
      authenticate = custom_options.delete(:authenticate) { true }

      options = base_options
      Extra.deep_merge!(options, auth_options(authenticate))
      Extra.deep_merge!(options, proxy_options)
      Extra.deep_merge!(custom_options, options)
    end

    def base_options
      {
          format:   :json,
          headers:  {
              'Accept' => 'application/json',
              'User-Agent' => user_agent,
          },
      }
    end

    def proxy_options
      options = {}

      if proxy
        address, port = proxy.split(":")
        options = { http_proxyaddr: address, http_proxyport: port }
      end

      options
    end

    def auth_options(authenticate)
      options = {}

      if password
        options = { basic_auth: { username: username, password: password } }
      elsif access_token
        options = { headers: { HEADER_AUTHORIZATION => "Bearer #{access_token}" } }
      else
        !authenticate or raise Error, "A password, domain API token or access token is required."
      end

      options
    end

    def content_type(headers)
      headers["Content-Type"] || "application/json"
    end

    def content_data(headers, data)
      headers["Content-Type"] == "application/json" ? JSON.dump(data) : data
    end

  end
end
