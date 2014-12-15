module Dnsimple
  class Client
    class ContactsService < ClientService

      # Lists the contacts in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#list
      #
      # @return [Array<Contact>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/contacts")

        response.map { |r| Contact.new(r["contact"]) }
      end

      # Creates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Contact]
      # @raise  [RequestError] When the request fails.
      def create(attributes = {})
        validate_mandatory_attributes(attributes, [:first_name, :last_name, :address1, :city, :state_province, :postal_code, :country, :phone, :email_address])
        options  = { body: { contact: attributes }}
        response = client.post("v1/contacts", options)

        Contact.new(response["contact"])
      end

      # Gets a contact from the account.
      #
      # @see http://developer.dnsimple.com/contacts/#get
      #
      # @param  [Fixnum] contact The contact id.
      #
      # @return [Contact]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(contact)
        response = client.get("v1/contacts/#{contact}")

        Contact.new(response["contact"])
      end

      # Updates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#update
      #
      # @param  [Fixnum] contact The contact id.
      # @param  [Hash] attributes
      #
      # @return [Contact]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update(contact, attributes = {})
        options  = { body: { contact: attributes }}
        response = client.put("v1/contacts/#{contact}", options)

        Contact.new(response["contact"])
      end

      # Deletes a contact from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/contacts/#delete
      #
      # @param  [Fixnum] contact The contact id.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete(contact)
        client.delete("v1/contacts/#{contact}")
      end

    end
  end
end
