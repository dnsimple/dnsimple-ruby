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
      @@base_uri = base_uri.gsub(/\/$/, '')
    end

    def self.load_credentials(path='~/.dnsimple')
      credentials = YAML.load(File.new(File.expand_path(path)))
      self.username = credentials['username']
      self.password = credentials['password']
      "Credentials loaded from #{path}" 
    end

    def self.standard_options
      {:basic_auth => credentials, :format => :json, :headers => {'Accept' => 'application/json'}}
    end
  end
end
