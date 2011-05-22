module DNSimple
  class Client
    def self.debug?
      @debug
    end
    def self.debug=(debug)
      @debug = debug
    end

    def self.username
      raise RuntimeError, "You must set your username first: DNSimple::Client.username = 'username'" unless defined?(@@username)
      @@username
    end

    def self.username=(username)
      @@username = username
    end

    def self.password
      raise RuntimeError, "You must set your password first: DNSimple::Client.password = 'password'" unless defined?(@@password)
      @@password
    end

    def self.password=(password)
      @@password = password
    end

    def self.credentials
      {:username => self.username, :password => self.password}
    end

    def self.base_uri
      @@base_uri ||= "https://dnsimple.com"
    end

    def self.base_uri=(base_uri)
      @@base_uri = base_uri ? base_uri.gsub(/\/$/, '') : nil
    end

    def self.load_credentials_if_necessary
      load_credentials unless credentials_loaded?
    end

    def self.config_path
      ENV['DNSIMPLE_CONFIG'] || '~/.dnsimple'
    end

    def self.load_credentials(path=config_path)
      credentials = YAML.load(File.new(File.expand_path(path)))
      self.username = credentials['username']
      self.password = credentials['password']
      self.base_uri = credentials['site']
      @@credentials_loaded = true
      "Credentials loaded from #{path}" 
    end

    def self.credentials_loaded?
      @@credentials_loaded ||= false
    end

    def self.standard_options
      {:format => :json, :headers => {'Accept' => 'application/json'}}
    end

    def self.standard_options_with_credentials
      standard_options.merge({:basic_auth => credentials})
    end
  end
end
