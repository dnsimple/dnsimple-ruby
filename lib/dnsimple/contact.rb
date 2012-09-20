class DNSimple::Contact < DNSimple::Base # Class representing a contact in DNSimple

  Aliases = {
    'first'             => 'first_name',
    'last'              => 'last_name',
    'state'             => 'state_province',
    'province'          => 'state_province',
    'state_or_province' => 'state_province',
    'email'             => 'email_address',
  }

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

  def name
    [first_name, last_name].join(' ')
  end

  def save(options={})
    contact_hash = {}
    %w(first_name last_name organization_name job_title address1 address2 city
    state_province postal_code country email_address phone phone_ext fax).each do |attribute|
      contact_hash[DNSimple::Contact.resolve(attribute)] = self.send(attribute)
    end

    options.merge!({:body => {:contact => contact_hash}})

    response = DNSimple::Client.put("contacts/#{id}", options)

    case response.code
    when 200
      return self
    else
      raise RequestError, "Error updating contact", response
    end
  end

  # Delete the contact from DNSimple. WARNING: this cannot be undone.
  def delete(options={})
    DNSimple::Client.delete("contacts/#{id}.json", options)
  end
  alias :destroy :delete

  # Map an aliased field name to it's real name. For example, if you
  # pass "first" it will be resolved to "first_name", "email" is resolved
  # to "email_address" and so on.
  def self.resolve(name)
    DNSimple::Contact::Aliases[name.to_s] || name
  end

  def self.resolve_attributes(attributes)
    resolved_attributes = {}
    attributes.each do |k, v|
      resolved_attributes[resolve(k)] = v
    end
    resolved_attributes
  end

  # Create the contact with the given attributes in DNSimple.
  # This method returns a Contact instance of the contact is created
  # and raises an error otherwise.
  def self.create(attributes, options={})
    contact_hash = resolve_attributes(attributes)

    options.merge!({:body => {:contact => contact_hash}})
    response = DNSimple::Client.post 'contacts.json', options

    case response.code
    when 201
      new(response["contact"])
    else
      raise RequestError, "Error creating contact", response
    end
  end

  def self.find(id, options={})
    response = DNSimple::Client.get "contacts/#{id}.json", options

    case response.code
    when 200
      new(response["contact"])
    when 404
      raise RecordNotFound, "Could not find contact #{id}"
    else
      raise RequestError, "Error finding contact", response
    end
  end

  def self.all(options={})
    response = DNSimple::Client.get 'contacts.json', options

    case response.code
    when 200
      response.map { |r| new(r["contact"]) }
    else
      raise RequestError, "Error listing contacts", response
    end
  end
end
