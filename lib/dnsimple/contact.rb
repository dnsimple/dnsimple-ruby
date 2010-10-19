module DNSimple #:nodoc:
  # CLass representing a contact in DNSimple
  class Contact
    include HTTParty

    # The contact ID in DNSimple
    attr_accessor :id

    # The name of the organization in which the contact works
    # (may be omitted)
    attr_accessor :organization_name

    # The contact first name
    attr_accessor :first_name

    # The contact last name
    attr_accessor :last_name

    # The contact's job title (may be omitted)
    attr_accessor :job_title

    # The contact street address
    attr_accessor :address1

    # Apartment or suite number
    attr_accessor :address2

    # The city name
    attr_accessor :city

    # The state or province name
    attr_accessor :state_province

    # The contact postal code
    attr_accessor :postal_code

    # The contact country (as a 2-character country code)
    attr_accessor :country

    # The contact email address
    attr_accessor :email_address

    # The contact phone number
    attr_accessor :phone

    # The contact phone extension (may be omitted)
    attr_accessor :phone_ext

    # The contact fax number (may be omitted)
    attr_accessor :fax

    # When the contact was created in DNSimple
    attr_accessor :created_at

    # When the contact was last updated in DNSimple
    attr_accessor :updated_at

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def name
      [first_name, last_name].join(' ')
    end

    def save(options={})
      contact_hash = {}
      %w(first_name last_name organization_name job_title address1 address2 city
      state_province postal_code country email_address phone phone_ext fax).each do |attribute|
        contact_hash[Contact.resolve(attribute)] = self.send(attribute)
      end

      options.merge!({:basic_auth => Client.credentials})
      options.merge!({:body => {:contact => contact_hash}})
      
      response = self.class.put("#{Client.base_uri}/contacts/#{id}.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        return self
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Failed to update contact: #{response.inspect}"
      end
    end

    # Delete the contact from DNSimple. WARNING: this cannot be undone.
    def delete(options={})
      options.merge!({:basic_auth => Client.credentials})
      self.class.delete("#{Client.base_uri}/contacts/#{id}.json", options)
    end

    # Map an aliased field name to it's real name. For example, if you
    # pass "first" it will be resolved to "first_name", "email" is resolved
    # to "email_address" and so on.
    def self.resolve(name)
      aliases = {
          'first' => 'first_name',
          'last' => 'last_name',
          'state' => 'state_province',
          'province' => 'state_province',
          'email' => 'email_address',
      }
      aliases[name] || name
    end

    # Create the contact with the given attributes in DNSimple.
    # This method returns a Contact instance of the contact is created
    # and raises an error otherwise.
    def self.create(attributes, options={})
      contact_hash = attributes

      options.merge!({:body => {:contact => contact_hash}})
      options.merge!({:basic_auth => Client.credentials})

      response = self.post("#{Client.base_uri}/contacts.json", options)

      pp response if Client.debug?

      case response.code
      when 201
        return Contact.new(response["contact"])
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Failed to create contact: #{response.inspect}"
      end
    end

    def self.find(id, options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/contacts/#{id}.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        return Contact.new(response["contact"])
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find contact #{id}"
      else
        raise DNSimple::Error.new(id, response["errors"])
      end
    end

    def self.all(options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/contacts.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| Contact.new(r["contact"]) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end
  end
end
