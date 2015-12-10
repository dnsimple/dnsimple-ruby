module Dnsimple
  class Client
    module DomainsRecords

      # Lists the records for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/records/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] options
      # @return [Array<Struct::Record>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def records(domain, options = {})
        response = client.get(Client.versioned("domains/#{domain}/records"), options)

        response.map { |r| Struct::Record.new(r["record"]) }
      end
      alias :list_record :records

      # Creates a record for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/records/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] attributes
      # @return [Struct::Record]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def create_record(domain, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = options.merge({ record: attributes })
        response = client.post(Client.versioned("domains/#{domain}/records"), options)

        Struct::Record.new(response["record"])
      end

      # Gets a record for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/records/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      # @return [Struct::Record]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def record(domain, record, options = {})
        response = client.get(Client.versioned("domains/#{domain}/records/#{record}"), options)

        Struct::Record.new(response["record"])
      end

      # Updates a record for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/records/#update
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      # @return [Struct::Record]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_record(domain, record, attributes = {}, options = {})
        options  = options.merge({ record: attributes })
        response = client.put(Client.versioned("domains/#{domain}/records/#{record}"), options)

        Struct::Record.new(response["record"])
      end

      # Deletes a record for a domain.
      #
      # @see http://developer.dnsimple.com/v1/domains/records/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_record(domain, record, options = {})
        client.delete(Client.versioned("domains/#{domain}/records/#{record}"), options)
      end

    end
  end
end
