module DNSimple

  # Represents a single domain.
  class Domain < Base
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

    # Delete the domain from DNSimple. WARNING: this cannot
    # be undone.
    def delete(options={})
      DNSimple::Client.delete("domains/#{name}", options)
    end
    alias :destroy :delete

    # Apply the given named template to the domain. This will add
    # all of the records in the template to the domain.
    def apply(template, options={})
      options.merge!(:body => {})
      template = resolve_template(template)

      DNSimple::Client.post("domains/#{name}/templates/#{template.id}/apply", options)
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
      response = DNSimple::Client.get("domains/#{name}/applied_services", options)

      case response.code
      when 200
        response.map { |r| DNSimple::Service.new(r["service"]) }
      else
        raise RequestError, "Error listing applied services", response
      end
    end

    def available_services(options={})
      response = DNSimple::Client.get("domains/#{name}/available_services", options)

      case response.code
      when 200
        response.map { |r| DNSimple::Service.new(r["service"]) }
      else
        raise RequestError, "Error listing available services", response
      end
    end

    def add_service(id_or_short_name, options={})
      options.merge!(:body => {:service => {:id => id_or_short_name}})
      response = DNSimple::Client.post("domains/#{name}/applied_services", options)

      case response.code
      when 200
        true
      else
        raise RequestError, "Error adding service", response
      end
    end

    def remove_service(id, options={})
      response = DNSimple::Client.delete("domains/#{name}/applied_services/#{id}", options)

      case response.code
      when 200
        true
      else
        raise RequestError, "Error removing service", response
      end
    end

    # Check the availability of a name
    def self.check(name, options={})
      response = DNSimple::Client.get("domains/#{name}/check", options)

      case response.code
      when 200
        "registered"
      when 404
        "available"
      else
        raise RequestError, "Error checking availability", response
      end
    end

    # Create the domain with the given name in DNSimple. This
    # method returns a Domain instance if the name is created
    # and raises an error otherwise.
    def self.create(name, options={})
      options.merge!({:body => {:domain => {:name => name}}})

      response = DNSimple::Client.post("domains", options)

      case response.code
      when 201
        new(response["domain"])
      else
        raise RequestError, "Error creating domain", response
      end
    end

    # Purchase a domain name.
    def self.register(name, registrant={}, extended_attributes={}, options={})
      body = {:domain => {:name => name}}
      if registrant
        if registrant[:id]
          body[:domain][:registrant_id] = registrant[:id]
        else
          body.merge!(:contact => DNSimple::Contact.resolve_attributes(registrant))
        end
      end
      body.merge!(:extended_attribute => extended_attributes)
      options.merge!({:body => body})

      response = DNSimple::Client.post("domain_registrations", options)

      case response.code
      when 201
        return DNSimple::Domain.new(response["domain"])
      else
        raise RequestError, "Error registering domain", response
      end
    end

    # Find a specific domain in the account either by the numeric ID
    # or by the fully-qualified domain name.
    def self.find(id_or_name, options={})
      id = id_or_name
      response = DNSimple::Client.get("domains/#{id}", options)

      case response.code
      when 200
        new(response["domain"])
      when 404
        raise RecordNotFound, "Could not find domain #{id}"
      else
        raise RequestError, "Error finding domain", response
      end
    end

    # Get all domains for the account.
    def self.all(options={})
      response = DNSimple::Client.get("domains", options)

      case response.code
      when 200
        response.map { |r| new(r["domain"]) }
      else
        raise RequestError, "Error listing domains", response
      end
    end

  end
end
