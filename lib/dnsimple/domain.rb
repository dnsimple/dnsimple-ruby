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
      options.merge!(standard_options)
      self.class.delete("#{Client.base_uri}/domains/#{id}", options)
    end
    alias :destroy :delete

    # Apply the given named template to the domain. This will add
    # all of the records in the template to the domain.
    def apply(template, options={})
      options.merge!(standard_options)
      template = resolve_template(template)
      self.class.post("#{Client.base_uri}/domains/#{id}/templates/#{template.id}/apply", options)
    end

    #:nodoc:
    def resolve_template(template)
      case template
      when DNSimple::Template
        template
      else
        DNSimple::Template.find(template)
      end
    end

    def applied_services(options={})
      options.merge!(standard_options)
      response = self.class.get("#{Client.base_uri}/domains/#{id}/applied_services", options)
      pp response if Client.debug?
      case response.code
      when 200
        response.map { |r| Service.new(r["service"]) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end

    def available_services(options={})
      options.merge!(standard_options)
      response = self.class.get("#{Client.base_uri}/domains/#{id}/available_services", options)
      pp response if Client.debug?
      case response.code
      when 200
        response.map { |r| Service.new(r["service"]) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end

    def add_service(id_or_short_name, options={})
      options.merge!(standard_options)
      options.merge!(:body => {:service => {:id => id_or_short_name}})
      response = self.class.post("#{Client.base_uri}/domains/#{name}/applied_services", options)
      pp response if Client.debug?
      case response.code
      when 200
        true
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise "Error: #{response.code}"
      end
    end

    def remove_service(id, options={})
      options.merge!(standard_options)
      response = self.class.delete("#{Client.base_uri}/domains/#{name}/applied_services/#{id}", options)
      pp response if Client.debug?
      case response.code
      when 200
        true
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise "Error: #{response.code}"
      end
    end

    # Check the availability of a name
    def self.check(name, options={})
      options.merge!(standard_options)
      response = self.get("#{Client.base_uri}/domains/#{name}/check", options)
      pp response if Client.debug?
      case response.code
      when 200
        "registered"
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        "available"
      else
        raise "Error: #{response.code}" 
      end
    end

    # Create the domain with the given name in DNSimple. This
    # method returns a Domain instance if the name is created
    # and raises an error otherwise.
    def self.create(name, options={})
      options.merge!(standard_options)

      domain_hash = {:name => name}
      options.merge!({:body => {:domain => domain_hash}})

      response = self.post("#{Client.base_uri}/domains", options)
      
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

    def self.register(name, registrant={}, extended_attributes={}, options={})
      options.merge!(standard_options)

      body = {:domain => {:name => name}}
      if registrant[:id]
        body[:domain][:registrant_id] = registrant[:id]
      else
        body.merge!(:contact => registrant)
      end
      body.merge!(:extended_attribute => extended_attributes)
      options.merge!({:body => body})
      
      response = self.post("#{Client.base_uri}/domain_registrations", options)
      
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

    # Find a specific domain in the account either by the numeric ID
    # or by the fully-qualified domain name.
    def self.find(id_or_name, options={})
      options.merge!(standard_options)
      response = self.get("#{Client.base_uri}/domains/#{id_or_name}", options)
      
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

    # Get all domains for the account.
    def self.all(options={})
      options.merge!(standard_options)
      response = self.get("#{Client.base_uri}/domains", options)
      
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

    def self.standard_options
      DNSimple::Client.standard_options
    end
    def standard_options
      DNSimple::Client.standard_options
    end
  end
end
