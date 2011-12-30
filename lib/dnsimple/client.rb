module DNSimple
  class Client
    include HTTParty

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

    def self.credentials
      {:username => self.username, :password => self.password}
    end

    def self.base_uri
      @base_uri ||= "https://dnsimple.com/"
    end

    def self.base_uri=(base_uri)
      @base_uri = base_uri
    end

    def self.load_credentials_if_necessary
      load_credentials unless credentials_loaded?
    end

    def self.config_path
      ENV['DNSIMPLE_CONFIG'] || '~/.dnsimple'
    end

    def self.load_credentials(path=config_path)
      begin
        credentials = YAML.load(File.new(File.expand_path(path)))
        self.username  = credentials['username']
        self.password  = credentials['password']
        self.api_token = credentials['api_token']
        self.base_uri  = credentials['site']
        @credentials_loaded = true
        "Credentials loaded from #{path}"
      rescue
        puts "Error loading your credentials: #{$!.message}"
        exit 1
      end
    end

    def self.credentials_loaded?
      (@credentials_loaded ||= false) or (username and (password or api_token))
    end

    def self.standard_options
      {:format => :json, :headers => {'Accept' => 'application/json'}}
    end

    def self.standard_options_with_credentials
      if password
        standard_options.merge({:basic_auth => credentials})
      else
        options = standard_options
        options[:headers]['X-DNSimple-Token'] = "#{username}:#{api_token}"
        options
      end
    end

    def self.get(path, options = {})
      super "#{base_uri}#{path}",
        standard_options_with_credentials.merge(options)
    end

    def self.post(path, options = {})
      super "#{base_uri}#{path}",
        standard_options_with_credentials.merge(options)
    end

    def self.put(path, options = {})
      super "#{base_uri}#{path}",
        standard_options_with_credentials.merge(options)
    end

    def self.delete(path, options = {})
      super "#{base_uri}#{path}",
        standard_options_with_credentials.merge(options)
    end
  end
end
