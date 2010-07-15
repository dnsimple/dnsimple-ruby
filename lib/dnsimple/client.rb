module DNSimple
  class Client
    def self.debug?
      @debug
    end
    def self.debug=(debug)
      @debug = debug
    end

    def self.username
      @@username
    end

    def self.username=(username)
      @@username = username
    end

    def self.password
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
  end
end
