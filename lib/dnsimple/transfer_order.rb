class DNSimple::TransferOrder # Class representing a transfer order in DNSimple
  attr_accessor :id

  attr_accessor :status

  def self.create(name, authinfo='', registrant={}, extended_attributes={}, options={})
    body = {:domain => {:name => name}, :transfer_order => {:authinfo => authinfo}}

    if registrant[:id]
      body[:domain][:registrant_id] = registrant[:id]
    else
      body.merge!(:contact => Contact.resolve_attributes(registrant))
    end

    body.merge!(:extended_attribute => extended_attributes)

    options.merge!({:body => body})

    response = DNSimple::Client.post 'domain_transfers.json', options
    pp response if DNSimple::Client.debug?

    case response.code
    when 201
      return new(response["transfer_order"])
    when 401
      raise RuntimeError, "Authentication failed"
    else
      raise DNSimple::Error.new(name, response["errors"])
    end
  end
end
