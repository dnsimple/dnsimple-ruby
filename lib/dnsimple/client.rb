module DNSimple
  class Client
    def self.debug?
      @debug
    end
    def self.debug=(debug)
      @debug = debug
    end

    def self.username=(username)
      self.credentials[:username] = username
    end

    def self.password=(password)
      self.credentials[:password] = password
    end

    def self.credentials(username=nil, password=nil)
      @credentials ||= {}
      @credentials = {:username => username, :password => password} if username && password
      @credentials
    end

    def self.base_uri(site=nil) 
      self.base_uri = site if site
      @@base_uri ||= "http://localhost:3000"
    end

    def self.base_uri=(base_uri)
      @@base_uri = base_uri.gsub(/\/$/, '')
      puts "Using #{@@base_uri}"
    end
  end
end
