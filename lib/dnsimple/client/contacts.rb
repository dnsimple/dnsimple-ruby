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
      #   client.contacts.list(1010, query: { page: 2 })
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def contacts(account_id, options = {})
        response = client.get(Client.versioned("/%s/contacts" % [account_id]), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Contact.new(r) })
      end
      alias :list :contacts
      alias :list_contacts :contacts

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
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Contact>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_contacts(account_id, options = {})
        paginate(:contacts, account_id, options)
      end
      alias :all :all_contacts

    end
  end
end
