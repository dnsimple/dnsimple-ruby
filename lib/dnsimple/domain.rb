module Dnsimple

  class Domain < Base
    # The Fixnum domain ID in DNSimple.
    attr_accessor :id

    # The Fixnum associated user ID.
    attr_accessor :user_id

    # The Fixnum associated registrant ID.
    attr_accessor :registrant_id

    # The String name.
    attr_accessor :name

    # The String state.
    attr_accessor :state

    # The String API token
    attr_accessor :token

    # Is the domain set to auto renew?
    attr_accessor :auto_renew

    # Is the whois information protected?
    attr_accessor :whois_protected

    # The Date the domain will expire.
    attr_accessor :expires_on

    # The Date the domain was created in DNSimple.
    attr_accessor :created_at

    # The Date the domain was last update in DNSimple.
    attr_accessor :updated_at


    # Check the availability of a name
    def self.check(name, options={})
      response = Client.get("v1/domains/#{name}/check", options)

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

      response = Client.post("v1/domain_registrations", options)

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

    private

    def auto_renew!(method)
      response = Client.send(method, "v1/domains/#{name}/auto_renewal")
      case response.code
      when 200
        self.auto_renew = response['domain']['auto_renew']
      else
        raise RequestError.new("Error setting auto_renew", response)
      end
    end
  end

end
