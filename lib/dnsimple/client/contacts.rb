# frozen_string_literal: true

module Dnsimple
  class Client
    module Contacts

      # Lists the contacts in the account.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#list
      # @see #all_contacts
      #
      # @example List contacts in the first page
      #   client.contacts.list(1010)
      #
      # @example List contacts, provide a specific page
      #   client.contacts.list(1010, page: 2)
      #
      # @example List contacts, provide a sorting policy
      #   client.contacts.list(1010, sort: "email:asc")
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def contacts(account_id, options = {})
        response = client.get(Client.versioned("/%s/contacts" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Contact.new(r) })
      end
      alias list_contacts contacts

      # Lists ALL the contacts in the account.
      #
      # This method is similar to {#contacts}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#list
      # @see #contacts
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_contacts(account_id, options = {})
        paginate(:contacts, account_id, options)
      end

      # Creates a contact in the account.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#create
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_contact(account_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:first_name, :last_name, :address1, :city, :state_province, :postal_code, :country, :phone, :email])
        response = client.post(Client.versioned("/%s/contacts" % [account_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Contact.new(response["data"]))
      end

      # Gets a contact from the account.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#get
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] contact_id the contact ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def contact(account_id, contact_id, options = {})
        response = client.get(Client.versioned("/%s/contacts/%s" % [account_id, contact_id]), options)

        Dnsimple::Response.new(response, Struct::Contact.new(response["data"]))
      end

      # Updates a contact in the account.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#update
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] contact_id the contact ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def update_contact(account_id, contact_id, attributes, options = {})
        response = client.patch(Client.versioned("/%s/contacts/%s" % [account_id, contact_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Contact.new(response["data"]))
      end

      # Deletes a contact from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/contacts/#delete
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] contact_id the contact ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_contact(account_id, contact_id, options = {})
        response = client.delete(Client.versioned("/%s/contacts/%s" % [account_id, contact_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
