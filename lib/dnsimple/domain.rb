module DNSimple #:nodoc:
  # Class representing a single domain in DNSimple.
  class Domain
    include HTTParty

    # The domain ID in DNSimple
    attr_accessor :id
    
    # The domain name
    attr_accessor :name
    
    # When the domain was created in DNSimple
    attr_accessor :created_at
    
    # When the domain was last update in DNSimple
    attr_accessor :updated_at

    # The current known name server status
    attr_accessor :name_server_status

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    # Delete the domain from DNSimple. WARNING: this cannot
    # be undone.
    def delete(options={})
      options.merge!({:basic_auth => Client.credentials})
      self.class.delete("#{Client.base_uri}/domains/#{id}.json", options)
    end
    alias :destroy :delete

    def apply(template_name, options={})
      template = DNSimple::Template.find(template_name)
      options.merge!({:basic_auth => Client.credentials})
      self.class.post("#{Client.base_uri}/domains/#{id}/templates/#{template.id}/apply", options)
    end

    # Create the domain with the given name in DNSimple. This
    # method returns a Domain instance if the name is created
    # and raises 
    def self.create(name, options={})
      domain_hash = {:name => name}
      
      options.merge!({:query => {:domain => domain_hash}})
      options.merge!({:basic_auth => Client.credentials})

      response = self.post("#{Client.base_uri}/domains.json", options)
      
      pp response if Client.debug?
      
      case response.code
      when 201
        return Domain.new(response["domain"])
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise DNSimple::Error.new(name, response["errors"])
      end
    end

    def self.find(id_or_name, options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/domains/#{id_or_name}.json", options)
      
      pp response if Client.debug?
      
      case response.code
      when 200
        return Domain.new(response["domain"])
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find domain #{id_or_name}"
      else
        raise DNSimple::Error.new(id_or_name, response["errors"])
      end
    end

    def self.all(options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/domains.json", options)
      
      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| Domain.new(r["domain"]) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end
  end
end
