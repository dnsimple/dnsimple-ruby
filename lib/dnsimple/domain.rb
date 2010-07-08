module DNSimple #:nodoc:
  # Class representing a single domain in DNSimple.
  class Domain
    include HTTParty
    base_uri 'http://localhost:3000/'

    # The domain ID in DNSimple
    attr_accessor :id
    
    # The domain name
    attr_accessor :name
    
    # When the domain was created in DNSimple
    attr_accessor :created_at
    
    # When the domain was last update in DNSimple
    attr_accessor :updated_at

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    # Delete the domain from DNSimple. WARNING: this cannot
    # be undone.
    def delete
      options = {}
      options.merge!({:basic_auth => Client.credentials})
      self.class.delete("/domains/#{id}.json", options)
    end

    # Create the domain with the given name in DNSimple. This
    # method returns a Domain instance if the name is created
    # and raises 
    def self.create(name)
      options = {:query => {:domain => {:name => name}}}
      options.merge!({:basic_auth => Client.credentials})
      response = self.post('/domains.json', options)
      pp response if Client.debug?
      if response.code == 201
        return Domain.new(response["domain"])
      else
        raise DNSimple::Error.new(name, response["errors"])
      end
    end

    def self.find(id)
      options = {}
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("/domains/#{id}.json", options)
      pp response; pp response.body if Client.debug?
      if response.code == 200
        return Domain.new(response["domain"])
      else
        raise DNSimple::Error.new(name, response["errors"])
      end
    end
  end
end
