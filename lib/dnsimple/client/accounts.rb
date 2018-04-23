module Dnsimple
  class Client
    module Accounts

      # Lists the accounts the authenticated entity has access to.
      #
      # @see https://developer.dnsimple.com/v2/accounts
      #
      # @example List the accounts:
      #   client.accounts.list
      #
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Account>]
      #
      # @raise  [Dnsimple::RequestError]
      def accounts(options = {})
        response = client.get(Client.versioned("/accounts"), options)

        Dnsimple::Response.new(response, response["data"].map { |r| Struct::Account.new(r) })
      end
      alias list accounts
      alias list_accounts accounts

    end
  end
end
