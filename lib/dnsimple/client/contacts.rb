module Dnsimple
  class Client
    module Contacts

      # Lists the contacts in the account.
      #
      # @see http://developer.dnsimple.com/v1/contacts/#list
      #
      # @return [Array<Struct::Contact>]
      #
      # @raise  [RequestError] When the request fails.
      def contacts(options = {})
        response = client.get(Client.versioned("/contacts"), options)

        response.map { |r| Struct::Contact.new(r["contact"]) }
      end
      alias :list :contacts
      alias :list_contacts :contacts

      # Creates a contact in the account.
      #
      # @see http://developer.dnsimple.com/v1/contacts/#create
      #
      # @param  [Hash] attributes
      # @return [Struct::Contact]
      #
      # @raise  [RequestError] When the request fails.
      def create_contact(attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:first_name, :last_name, :address1, :city, :state_province, :postal_code, :country, :phone, :email_address])
        options  = options.merge(contact: attributes)
        response = client.post(Client.versioned("/contacts"), options)

        Struct::Contact.new(response["contact"])
      end
      alias :create :create_contact

      # Gets a contact from the account.
      #
      # @see http://developer.dnsimple.com/v1/contacts/#get
      #
      # @param  [Fixnum] contact The contact id.
      # @return [Struct::Contact]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def contact(contact, options = {})
        response = client.get(Client.versioned("/contacts/#{contact}"), options)

        Struct::Contact.new(response["contact"])
      end

      # Updates a contact in the account.
      #
      # @see http://developer.dnsimple.com/v1/contacts/#update
      #
      # @param  [Fixnum] contact The contact id.
      # @param  [Hash] attributes
      # @return [Struct::Contact]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_contact(contact, attributes = {}, options = {})
        options  = options.merge(contact: attributes)
        response = client.put(Client.versioned("/contacts/#{contact}"), options)

        Struct::Contact.new(response["contact"])
      end
      alias :update :update_contact

      # Deletes a contact from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/v1/contacts/#delete
      #
      # @param  [Fixnum] contact The contact id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_contact(contact, options = {})
        client.delete(Client.versioned("contacts/#{contact}"), options)
      end
      alias :delete :delete_contact

    end
  end
end
