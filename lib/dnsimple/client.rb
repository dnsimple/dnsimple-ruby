require 'uri'
require 'httparty'
require 'dnsimple/extra'
require 'dnsimple/struct'
require 'dnsimple/response'
require 'dnsimple/client/clients'

module Dnsimple

  # Client for the DNSimple API
  #
  # @see https://developer.dnsimple.com/
  # @see https://developer.dnsimple.com/sandbox/
  # @see #base_url
  #
  # @example Default (Production)
  #   require "dnsimple"
  #
  #   client = Dnsimple::Client.new(access_token: "abc")
  #
  # @example Custom Base URL (Sandbox)
  #   require 'dnsimple'
  #
  #   client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: "abc")
  class Client

    HEADER_AUTHORIZATION = "Authorization".freeze

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
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.
    # @!attribute proxy
    #   @return [String,nil] Configure address:port values for proxy server

    attr_accessor :username, :password, :domain_api_token, :access_token,
                  :user_agent, :proxy


    def initialize(options = {})
      defaults = Dnsimple::Default.options

      Dnsimple::Default.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || defaults[key])
      end

      @services = {}
      @uri_parser = URI::Parser.new
    end


    # Base URL for API requests.
    #
    # It defaults to <tt>"https://api.dnsimple.com"</tt>.
    # For testing purposes use <tt>"https://api.sandbox.dnsimple.com"</tt>.
    #
    # @return [String] Base URL
    #
    # @see https://developer.dnsimple.com/sandbox/
    #
    # @example Default (Production)
    #   require "dnsimple"
    #
    #   client = Dnsimple::Client.new(access_token: "abc")
    #
    # @example Custom Base URL (Sandbox)
    #   require 'dnsimple'
    #
    #   client = Dnsimple::Client.new(base_url: "https://api.sandbox.dnsimple.com", access_token: "abc")
    def base_url
      Extra.join_uri(@base_url, "")
    end


    # Make a HTTP GET request.
    #
    # @param  [String] path The path, relative to {#base_url}
    # @param  [Hash] options The query and header params for the request
    # @return [HTTParty::Response]
    def get(path, options = {})
      execute :get, path, nil, options.to_h
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

      url = @uri_parser.escape(base_url + path)
      HTTParty.send(method, url, request_options)
    end


    private

    def request_options(custom_options = {})
      base_options.tap do |options|
        Extra.deep_merge!(options, custom_options)
        Extra.deep_merge!(options, headers: { "User-Agent" => format_user_agent })
        add_auth_options!(options)
        add_proxy_options!(options)
      end
    end

    def base_options
      {
          format:   :json,
          headers:  {
              "Accept" => "application/json",
          },
      }
    end

    def add_proxy_options!(options)
      return if proxy.nil?

      address, port = proxy.split(":")
      options[:http_proxyaddr] = address
      options[:http_proxyport] = port
    end

    def add_auth_options!(options)
      if password
        options[:basic_auth] = { username: username, password: password }
      elsif access_token
        options[:headers][HEADER_AUTHORIZATION] = "Bearer #{access_token}"
      end
    end

    # Builds the final user agent to use for HTTP requests.
    #
    # If no custom user agent is provided, the default user agent is used.
    #
    #     dnsimple-ruby/1.0
    #
    # If a custom user agent is provided, the final user agent is the combination
    # of the custom user agent prepended by the default user agent.
    #
    #     dnsimple-ruby/1.0 customAgentFlag
    #
    def format_user_agent
      if user_agent.to_s.empty?
        Dnsimple::Default::USER_AGENT
      else
        "#{Dnsimple::Default::USER_AGENT} #{user_agent}"
      end
    end

    def content_type(headers)
      headers["Content-Type"] || "application/json"
    end

    def content_data(headers, data)
      headers["Content-Type"] == "application/json" ? JSON.dump(data) : data
    end

  end
end
