module DNSimple #:nodoc:
  # Class representing a transfer order in DNSimple
  class TransferOrder
    include HTTParty

    attr_accessor :id

    attr_accessor :status

    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def self.create(name, authinfo='', registrant={}, extended_attributes={}, options={})
      body = {:domain => {:name => name}, :transfer_order => {:authinfo => authinfo}}

      if registrant[:id]
        body[:domain][:registrant_id] = registrant[:id]
      else
        body.merge!(:contact => registrant)
      end

      body.merge!(:extended_attribute => extended_attributes)

      options.merge!({:body => body})
      options.merge!({:basic_auth => Client.credentials})

      response = self.post("#{Client.base_uri}/domain_transfers.json", options)

      pp response if Client.debug?

      case response.code
      when 201
        return TransferOrder.new(response["transfer_order"])
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise DNSimple::Error.new(name, response["errors"])
      end
    end
  end
end
