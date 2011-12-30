class DNSimple::Domain < DNSimple::Base # Class representing a single domain in DNSimple.
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
    DNSimple::Client.delete "domains/#{name}", options
  end
  alias :destroy :delete

  # Apply the given named template to the domain. This will add
  # all of the records in the template to the domain.
  def apply(template, options={})
    options.merge!(:body => {})
    template = resolve_template(template)

    DNSimple::Client.post "domains/#{name}/templates/#{template.id}/apply",
      options
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
    response = DNSimple::Client.get "domains/#{name}/applied_services",
      options

    case response.code
    when 200
      response.map { |r| DNSimple::Service.new(r["service"]) }
    else
      raise RuntimeError, "Error: #{response.code}"
    end
  end

  def available_services(options={})
    response = DNSimple::Client.get "domains/#{name}/available_services",
      options

    case response.code
    when 200
      response.map { |r| DNSimple::Service.new(r["service"]) }
    else
      raise RuntimeError, "Error: #{response.code}"
    end
  end

  def add_service(id_or_short_name, options={})
    options.merge!(:body => {:service => {:id => id_or_short_name}})
    response = DNSimple::Client.post "domains/#{name}/applied_services",
      options

    case response.code
    when 200
      true
    else
      raise "Error: #{response.code}"
    end
  end

  def remove_service(id, options={})
    response = DNSimple::Client.delete("domains/#{name}/applied_services/#{id}", options)

    case response.code
    when 200
      true
    else
      raise "Error: #{response.code}"
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
      raise "Error: #{response.code}"
    end
  end

  # Create the domain with the given name in DNSimple. This
  # method returns a Domain instance if the name is created
  # and raises an error otherwise.
  def self.create(name, options={})
    options.merge!({:body => {:domain => {:name => name}}})

    response = DNSimple::Client.post('domains', options)

    case response.code
    when 201
      return new(response["domain"])
    else
      raise DNSimple::DomainError.new(name, response["errors"])
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

    response = DNSimple::Client.post('domain_registrations', options)

    case response.code
    when 201
      return DNSimple::Domain.new(response["domain"])
    else
      raise DNSimple::DomainError.new(name, response["errors"])
    end
  end

  # Find a specific domain in the account either by the numeric ID
  # or by the fully-qualified domain name.
  def self.find(id_or_name, options={})
    response = DNSimple::Client.get "domains/#{id_or_name}", options

    case response.code
    when 200
      return new(response["domain"])
    when 404
      raise RuntimeError, "Could not find domain #{id_or_name}"
    else
      raise DNSimple::Error.new(id_or_name, response["errors"])
    end
  end

  # Get all domains for the account.
  def self.all(options={})
    response = DNSimple::Client.get 'domains', options

    case response.code
    when 200
      response.map { |r| new(r["domain"]) }
    else
      raise RuntimeError, "Error: #{response.code}"
    end
  end
end
