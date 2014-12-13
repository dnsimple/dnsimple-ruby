module Dnsimple
  class Domain < Base

    # The domain ID in DNSimple
    attr_accessor :id

    # The domain name
    attr_accessor :name

    # When the domain was created in DNSimple
    attr_accessor :created_at

    # When the domain was last update in DNSimple
    attr_accessor :updated_at

    # When the domain is due to expire
    attr_accessor :expires_on

    # The state of the domain in DNSimple
    attr_accessor :state

    # ID of the registrant in DNSimple
    attr_accessor :registrant_id

    # User ID in DNSimple
    attr_accessor :user_id

    # Is the domain set to autorenew
    attr_accessor :auto_renew
    
    # Is the whois information protected
    attr_accessor :whois_protected


    # Lists the domains in the DNSimple account.
    #
    # @return [Array<Domain>]
    def self.list(options = {})
      response = Client.get("/v1/domains", options)

      case response.code
      when 200
        response.map { |r| new(r["domain"]) }
      else
        raise RequestError.new("Error listing domains", response)
      end
    end

    def self.all(*args); list(*args); end

    # Creates the domain in the DNSimple account.
    #
    # @param  [String] name The domain name.
    #
    # @return [Domain] The newly created domain.
    # @raise  [RequestError] When the request fails.
    def self.create(name)
      options = { body: { domain: { name: name }}}

      response = Client.post("/v1/domains", options)

      case response.code
      when 201
        new(response["domain"])
      else
        raise RequestError.new("Error creating domain", response)
      end
    end

    # Gets a specific domain in the account.
    #
    # @param [Fixnum,String] id Either the numeric ID or the fully-qualified domain name.
    #
    # @return [Domain] The domain.
    # @raise  [RecordNotFound] When the domain doesn't exist.
    # @raise  [RequestError] When the request fails.
    def self.find(id)
      response = Client.get("/v1/domains/#{id}")

      case response.code
      when 200
        new(response["domain"])
      when 404
        raise RecordNotFound, "Could not find domain #{id}"
      else
        raise RequestError.new("Error finding domain", response)
      end
    end

    # Deletes a specific domain from the account.
    #
    # WARNING: this cannot be undone.
    #
    # @param [Fixnum,String] id Either the numeric ID or the fully-qualified domain name.
    #
    # @return [void]
    # @raise  [RecordNotFound] When the domain doesn't exist.
    # @raise  [RequestError] When the request fails.
    def self.delete(id)
      response = Client.delete("/v1/domains/#{id}")

      case response.code
      when 200, 204
        true
      when 404
        raise RecordNotFound, "Could not find domain #{id}"
      else
        raise RequestError.new("Error deleting domain", response)
      end
    end

    # Check the availability of a name
    def self.check(name, options={})
      response = Client.get("/v1/domains/#{name}/check", options)

      case response.code
        when 200
          "registered"
        when 404
          "available"
        else
          raise RequestError.new("Error checking availability", response)
      end
    end

    # Purchase a domain name.
    def self.register(name, registrant={}, extended_attributes={}, options={})
      body = {:domain => {:name => name}}
      if registrant
        if registrant[:id]
          body[:domain][:registrant_id] = registrant[:id]
        else
          body.merge!(:contact => Contact.resolve_attributes(registrant))
        end
      end
      body.merge!(:extended_attribute => extended_attributes)
      options.merge!({:body => body})

      response = Client.post("/v1/domain_registrations", options)

      case response.code
      when 201
        return Domain.new(response["domain"])
      else
        raise RequestError.new("Error registering domain", response)
      end
    end


    # Enable auto_renew on the domain
    def enable_auto_renew
      return if auto_renew
      auto_renew!(:post)
    end

    # Disable auto_renew on the domain
    def disable_auto_renew
      return unless auto_renew
      auto_renew!(:delete)
    end

    # Deletes this domain from the account.
    #
    # WARNING: this cannot be undone.
    #
    # @see .delete
    def delete
      self.class.delete(name)
    end
    alias :destroy :delete

    # Apply the given named template to the domain. This will add
    # all of the records in the template to the domain.
    def apply(template, options={})
      options.merge!(:body => {})
      template = resolve_template(template)

      Client.post("/v1/domains/#{name}/templates/#{template.id}/apply", options)
    end

    def resolve_template(template)
      case template
      when Template
        template
      else
        Template.find(template)
      end
    end

    def applied_services(options={})
      response = Client.get("/v1/domains/#{name}/applied_services", options)

      case response.code
      when 200
        response.map { |r| Service.new(r["service"]) }
      else
        raise RequestError.new("Error listing applied services", response)
      end
    end

    def available_services(options={})
      response = Client.get("/v1/domains/#{name}/available_services", options)

      case response.code
      when 200
        response.map { |r| Service.new(r["service"]) }
      else
        raise RequestError.new("Error listing available services", response)
      end
    end

    def add_service(id_or_short_name, options={})
      options.merge!(:body => {:service => {:id => id_or_short_name}})
      response = Client.post("/v1/domains/#{name}/applied_services", options)

      case response.code
      when 200
        true
      else
        raise RequestError.new("Error adding service", response)
      end
    end

    def remove_service(id, options={})
      response = Client.delete("/v1/domains/#{name}/applied_services/#{id}", options)

      case response.code
      when 200
        true
      else
        raise RequestError.new("Error removing service", response)
      end
    end


    private

    def auto_renew!(method)
      response = Client.send(method, "/v1/domains/#{name}/auto_renewal")
      case response.code
      when 200
        self.auto_renew = response['domain']['auto_renew']
      else
        raise RequestError.new("Error setting auto_renew", response)
      end
    end

  end
end
