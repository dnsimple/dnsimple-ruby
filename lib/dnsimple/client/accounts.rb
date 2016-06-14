module Dnsimple
  class Client
    module Accounts

      def accounts(options = {})
        response = client.get(Client.versioned("/accounts"), options)

        Dnsimple::Response.new(response, response["data"].map { |r| Struct::Account.new(r) })
      end
      alias list accounts
      alias list_accounts accounts

    end
  end
end
