module Dnsimple
  class Client
    module Contacts

      # Lists the contacts in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#list
      #
      # @return [Array<Struct::Contact>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/contacts")

        response.map { |r| Struct::Contact.new(r["contact"]) }
      end

      # Creates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Struct::Contact]
      # @raise  [RequestError] When the request fails.
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:first_name, :last_name, :address1, :city, :state_province, :postal_code, :country, :phone, :email_address])
        options  = { contact: attributes }
        response = client.post("v1/contacts", options)

        Struct::Contact.new(response["contact"])
      end

      # Gets a contact from the account.
      #
      # @see http://developer.dnsimple.com/contacts/#get
      #
      # @param  [Fixnum] contact The contact id.
      #
      # @return [Struct::Contact]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(contact)
        response = client.get("v1/contacts/#{contact}")

        Struct::Contact.new(response["contact"])
      end

      # Updates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#update
      #
      # @param  [Fixnum] contact The contact id.
      # @param  [Hash] attributes
      #
      # @return [Struct::Contact]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update(contact, attributes = {})
        options  = { contact: attributes }
        response = client.put("v1/contacts/#{contact}", options)

        Struct::Contact.new(response["contact"])
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
