module DNSimple
  class Client
    def self.debug?
      @debug
    end
    def self.debug=(debug)
      @debug = debug
    end
    def self.credentials(username=nil, password=nil)
      @credentials = {:username => username, :password => password} if username && password
      @credentials
    end
  end
end
