module Dnsimple
  class Client
    module DomainsRecords

      # Lists the records for a domain.
      #
      # @see http://developer.dnsimple.com/domains/records/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] options
      #
      # @return [Array<Struct::Record>]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def records(domain, options = {})
        response = client.get("v1/domains/#{domain}/records", options)

        response.map { |r| Struct::Record.new(r["record"]) }
      end
      alias :list_record :records

      # Creates a record for a domain.
      #
      # @see http://developer.dnsimple.com/domains/records/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] attributes
      #
      # @return [Struct::Record]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def create_record(domain, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = { record: attributes }
        response = client.post("v1/domains/#{domain}/records", options)

        Struct::Record.new(response["record"])
      end

      # Gets a record for a domain.
      #
      # @see http://developer.dnsimple.com/domains/records/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      #
      # @return [Struct::Record]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def record(domain, record)
        response = client.get("v1/domains/#{domain}/records/#{record}")

        Struct::Record.new(response["record"])
      end

      # Updates a record for a domain.
      #
      # @see http://developer.dnsimple.com/domains/records/#update
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      #
      # @return [Struct::Record]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_record(domain, record, attributes = {})
        options  = { record: attributes }
        response = client.put("v1/domains/#{domain}/records/#{record}", options)

        Struct::Record.new(response["record"])
      end

      # Deletes a record for a domain.
      #
      # @see http://developer.dnsimple.com/domains/records/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      #
      # @return [void]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_record(domain, record)
        client.delete("v1/domains/#{domain}/records/#{record}")
      end

    end
  end
end
