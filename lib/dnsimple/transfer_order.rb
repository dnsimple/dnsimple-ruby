module Dnsimple

  # Represents a transfer order.
  class TransferOrder < Base

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

      response = Client.post("/v1/domain_transfers", options)

      case response.code
      when 201
        new(response["transfer_order"])
      else
        raise RequestError.new("Error creating transfer order", response)
      end
    end

  end
end
