module Dnsimple
  class Client
    class RecordsService < ClientService

      # Lists the records in the account.
      #
      # @see http://developer.dnsimple.com/domains/records/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] options
      #
      # @return [Array<Record>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list(domain, options = {})
        response = client.get("v1/domains/#{domain}/records", options)

        response.map { |r| Record.new(r["record"]) }
      end

      # Creates a record in the account.
      #
      # @see http://developer.dnsimple.com/domains/records/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] attributes
      #
      # @return [Record]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def create(domain, attributes = {})
        validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = { body: { record: attributes }}
        response = client.post("v1/domains/#{domain}/records", options)

        Record.new(response["record"])
      end

      # Gets a record from the account.
      #
      # @see http://developer.dnsimple.com/domains/records/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      #
      # @return [Record]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(domain, record)
        response = client.get("v1/domains/#{domain}/records/#{record}")

        Record.new(response["record"])
      end

      # Updates a record in the account.
      #
      # @see http://developer.dnsimple.com/domains/records/#update
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      #
      # @return [Record]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update(domain, record, attributes = {})
        options  = { body: { record: attributes }}
        response = client.put("v1/domains/#{domain}/records/#{record}", options)

        Record.new(response["record"])
      end

      # Deletes a record from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/domains/records/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] record The record id.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete(domain, record)
        client.delete("v1/domains/#{domain}/records/#{record}")
      end

    end
  end
end
