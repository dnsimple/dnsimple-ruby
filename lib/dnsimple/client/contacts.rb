module Dnsimple
  class Client
    module Contacts

      # Lists the contacts in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#list
      #
      # @return [Array<Struct::Contact>]
      #
      # @raise  [RequestError] When the request fails.
      def contacts(options = {})
        response = client.get("v1/contacts", options)

        response.map { |r| Struct::Contact.new(r["contact"]) }
      end
      alias :list :contacts
      alias :list_contacts :contacts

      # Creates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#create
      #
      # @param  [Hash] attributes
      # @return [Struct::Contact]
      #
      # @raise  [RequestError] When the request fails.
      def create_contact(attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:first_name, :last_name, :address1, :city, :state_province, :postal_code, :country, :phone, :email_address])
        options  = options.merge(contact: attributes)
        response = client.post("v1/contacts", options)

        Struct::Contact.new(response["contact"])
      end
      alias :create :create_contact

      # Gets a contact from the account.
      #
      # @see http://developer.dnsimple.com/contacts/#get
      #
      # @param  [Fixnum] contact The contact id.
      # @return [Struct::Contact]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def contact(contact, options = {})
        response = client.get("v1/contacts/#{contact}", options)

        Struct::Contact.new(response["contact"])
      end

      # Updates a contact in the account.
      #
      # @see http://developer.dnsimple.com/contacts/#update
      #
      # @param  [Fixnum] contact The contact id.
      # @param  [Hash] attributes
      # @return [Struct::Contact]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_contact(contact, attributes = {}, options = {})
        options  = options.merge(contact: attributes)
        response = client.put("v1/contacts/#{contact}", options)

        Struct::Contact.new(response["contact"])
      end
      alias :update :update_contact

      # Deletes a contact from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/contacts/#delete
      #
      # @param  [Fixnum] contact The contact id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_contact(contact, options = {})
        client.delete("v1/contacts/#{contact}", options)
      end
      alias :delete :delete_contact

    end
  end
end
