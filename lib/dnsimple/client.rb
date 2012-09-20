require 'yaml'

module DNSimple
  class Client

    def self.debug?
      @debug
    end

    def self.debug=(debug)
      @debug = debug
    end

    def self.username
      @username
    end

    def self.username=(username)
      @username = username
    end

    def self.password
      @password
    end

    def self.password=(password)
      @password = password
    end

    def self.api_token
      @api_token
    end

    def self.api_token=(api_token)
      @api_token = api_token
    end

    # Sets the @host value.
    #
    # @returns [String] The host value.
    def self.host
      @host
    end

    # Gets the @host value.
    #
    # @param [String] value The host value.
    def self.host=(value)
      @host = value
    end

    # Gets the qualified API base uri.
    #
    # @return [String] The qualified API base uri.
    def self.base_uri
      "https://#{(host || "dnsimple.com")}/"
    end

    def self.base_uri=(value)
      DNSimple.deprecate("Dnsimple::Client.base_uri is deprecated. Please use Dnsimple::Client.host and provide a simple host.")
      self.host = URI.parse(value).host
    end

    def self.http_proxy
      @http_proxy
    end

    def self.http_proxy=(http_proxy)
      @http_proxy = http_proxy
    end

    def self.load_credentials_if_necessary
      load_credentials unless credentials_loaded?
    end

    def self.config_path
      ENV['DNSIMPLE_CONFIG'] || '~/.dnsimple'
    end

    def self.load_credentials(path = config_path)
      begin
        credentials = YAML.load(File.new(File.expand_path(path)))
        self.username   ||= credentials['username']
        self.password   ||= credentials['password']
        self.api_token  ||= credentials['api_token']
        self.base_uri     = credentials['site']      if credentials['site']
        self.host         = credentials['host']      if credentials['host']
        self.http_proxy = { :addr => credentials['proxy_addr'], :port => credentials['proxy_port'] }
        @credentials_loaded = true
        puts "Credentials loaded from #{path}"
      rescue => error
        puts "Error loading your credentials: #{error.message}"
        exit 1
      end
    end

    def self.credentials_loaded?
      (@credentials_loaded ||= false) or (username and (password or api_token))
    end

    def self.standard_options
      options = {
                  :format => :json,
                  :headers => {'Accept' => 'application/json'},
                }

      if http_proxy
        options.merge!(
          :http_proxyaddr => self.http_proxy[:addr],
          :http_proxyport => self.http_proxy[:port]
        )
      end

      if password
        options[:basic_auth] = {:username => username, :password => password}
      elsif api_token
        options[:headers]['X-DNSimple-Token'] = "#{username}:#{api_token}"
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
      response = HTTParty.send(method, "#{base_uri}#{path}",
        standard_options.merge(options))

      if response.code == 401
        raise AuthenticationFailed
      end

      response
    end

  end
end
